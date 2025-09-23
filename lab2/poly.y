%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "poly.h"
NamedPolynomial poly_vars[MAX_POLYNOMIALS] = {0};
extern int yylex();
extern int yyerror(char *s);
extern FILE *yyin;
extern int yylineno;
%}
%union {
    int num;
    char var;
    AST ast;
}
%type <ast> expr addexpr mulexpr power unary primary
%token <num> NUMBER
%token <var> VAR POLYVAR
%token PLUS MINUS TIMES POWER LPAREN RPAREN ASSIGN PRINT EOL IMPLICIT_MUL NEG
%left PLUS MINUS
%right NEG
%left TIMES IMPLICIT_MUL
%right POWER
%right UMINUS
%start program
%%
program: /* empty */
       | program statement
       | program statement EOL
       | program EOL
       ;
statement: assignment
         | print_stmt
         | expr {
             Polynomial *p = eval_ast($1);
             if (p) {
                 poly_print(p);
                 poly_free(p);
             }
             ast_free($1);
           }
         ;
assignment: POLYVAR ASSIGN expr {
             char name = $1;
             int idx = name - 'a';
             Polynomial *newp = eval_ast($3);
             if (newp) {
                 if (poly_vars[idx].poly) poly_free(poly_vars[idx].poly);
                 poly_vars[idx].poly = newp;
                 poly_vars[idx].is_defined = 1;
                 poly_vars[idx].name = name;
             }
             ast_free($3);
           }
         ;
print_stmt: PRINT expr {
             Polynomial *p = eval_ast($2);
             if (p) {
                 poly_print(p);
                 poly_free(p);
             }
             ast_free($2);
           }
          ;
expr: addexpr { $$ = $1; }
    ;
addexpr: mulexpr %prec NEG { $$ = $1; }
       | addexpr PLUS mulexpr { $$ = ast_create(AST_ADD, $1, $3, 0, '\0'); }
       | addexpr MINUS mulexpr { $$ = ast_create(AST_SUB, $1, $3, 0, '\0'); }
       ;
mulexpr: power { $$ = $1; }
       | mulexpr TIMES power { $$ = ast_create(AST_MUL, $1, $3, 0, '\0'); }
       | mulexpr power %prec IMPLICIT_MUL { $$ = ast_create(AST_MUL, $1, $2, 0, '\0'); }
       ;
power: unary %prec POWER { $$ = $1; }
     | unary POWER power { $$ = ast_create(AST_POW, $1, $3, 0, '\0'); }
     ;
unary: primary { $$ = $1; }
     | MINUS power %prec UMINUS { $$ = ast_create(AST_UMINUS, $2, NULL, 0, '\0'); }
     ;
primary: NUMBER { $$ = ast_create(AST_NUM, NULL, NULL, $1, '\0'); }
       | VAR { $$ = ast_create(AST_VAR, NULL, NULL, 0, $1); }
       | POLYVAR { $$ = ast_create(AST_POLYVAR, NULL, NULL, 0, $1); }
       | LPAREN expr RPAREN { $$ = $2; }
       ;
%%
int yyerror(char *s) {
    fprintf(stderr, "Line %d: Syntax error: %s\n", yylineno, s);
    return 0;
}
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("fopen");
        return 1;
    }
  
    yyparse();
    fclose(yyin);
    /* Cleanup */
    for (int i = 0; i < MAX_POLYNOMIALS; i++) {
        if (poly_vars[i].poly) poly_free(poly_vars[i].poly);
    }
    return 0;
}
/* AST functions */
AST ast_create(ASTType type, AST left, AST right, int num, char var) {
    AST node = malloc(sizeof(struct ASTNode));
    node->type = type;
    node->line = yylineno;
    node->left = left;
    node->right = right;
 
    switch(type) {
        case AST_NUM: node->u.num = num; break;
        case AST_VAR: node->u.var_name = var; break;
        case AST_POLYVAR: node->u.poly_name = var; break;
    }
    return node;
}
void ast_free(AST node) {
    if (!node) return;
    ast_free(node->left);
    ast_free(node->right);
    free(node);
}
void trim_poly(Polynomial *p) {
    if (!p || p->degree < 0) return;
    while (p->degree > 0 && p->coeffs[p->degree] == 0) {
        p->degree--;
    }
    if (p->degree == 0 && p->coeffs[0] == 0) {
        p->degree = -1;
    }
}
/* Helper for binary operations */
static Polynomial* eval_binary_op(AST node, Polynomial* (*op)(Polynomial*, Polynomial*)) {
    Polynomial *a = eval_ast(node->left);
    if (!a) a = poly_from_number(0);
    Polynomial *b = eval_ast(node->right);
    if (!b) b = poly_from_number(0);
    Polynomial *res = op(a, b);
    poly_free(a);
    poly_free(b);
    trim_poly(res);
    return res;
}
/* Eval AST to Polynomial */
Polynomial* eval_ast(AST node) {
    if (!node) return NULL;
    switch (node->type) {
        case AST_NUM:
            return poly_from_number(node->u.num);
        case AST_VAR:
            return poly_from_var_power(1);
        case AST_POLYVAR: {
            char name = node->u.poly_name;
            int idx = name - 'a';
            if (idx < 0 || idx >= MAX_POLYNOMIALS || !poly_vars[idx].is_defined || poly_vars[idx].name != name) {
                fprintf(stderr, "Line %d: Semantic error: Undefined polynomial '%c'\n", node->line, name);
                return poly_from_number(0);
            }
            return copy_poly(poly_vars[idx].poly);
        }
        case AST_ADD:
            return eval_binary_op(node, poly_add);
        case AST_SUB:
            return eval_binary_op(node, poly_subtract);
        case AST_MUL:
            return eval_binary_op(node, poly_multiply);
        case AST_POW: {
            Polynomial *base = eval_ast(node->left);
            if (!base) return NULL;
            Polynomial *exp_poly = eval_ast(node->right);
            if (!exp_poly) {
                poly_free(base);
                return NULL;
            }
            if (exp_poly->degree != 0) {
                fprintf(stderr, "Line %d: Semantic error: Exponent must be constant polynomial\n", node->line);
                poly_free(base);
                poly_free(exp_poly);
                return poly_from_number(0);
            }
            int exp = exp_poly->coeffs[0];
            poly_free(exp_poly);
            if (exp < 0) {
                fprintf(stderr, "Line %d: Semantic error: Power must be non-negative integer, got %d\n",
                        node->line, exp);
                poly_free(base);
                return poly_from_number(0);
            }
            Polynomial *res = poly_pow(base, exp);
            poly_free(base);
            trim_poly(res);
            return res;
        }
        case AST_UMINUS: {
            Polynomial *c = eval_ast(node->left);
            Polynomial *res = poly_multiply_scalar(c, -1);
            poly_free(c);
            trim_poly(res);
            return res;
        }
        default:
            fprintf(stderr, "Line %d: Semantic error: Unknown AST type\n", node->line);
            return poly_from_number(0);
    }
}
/* Poly functions (updated with trim) */
Polynomial* poly_from_number(int num) {
    Polynomial *p = (Polynomial *)malloc(sizeof(Polynomial));
    p->coeffs = (int*)calloc(1, sizeof(int));
    p->coeffs[0] = num;
    p->degree = (num != 0) ? 0 : -1;
    p->capacity = 1;
    return p;
}
Polynomial* poly_from_var_power(int power) {
    Polynomial *p = (Polynomial *)malloc(sizeof(Polynomial));
    p->capacity = power + 1;
    p->coeffs = (int*)calloc(p->capacity, sizeof(int));
    p->coeffs[power] = 1;
    p->degree = power;
    return p;
}
Polynomial* poly_add(Polynomial *a, Polynomial *b) {
    int adeg = a->degree < 0 ? -1 : a->degree;
    int bdeg = b->degree < 0 ? -1 : b->degree;
    int max_degree = (adeg > bdeg) ? adeg : bdeg;
    if (max_degree < 0) {
        return poly_from_number(0);
    }
    Polynomial *result = malloc(sizeof(Polynomial));
    result->capacity = max_degree + 1;
    result->coeffs = calloc(result->capacity, sizeof(int));
    result->degree = max_degree;
    for (int i = 0; i <= max_degree; i++) {
        int ca = (adeg >= 0 && i <= adeg) ? a->coeffs[i] : 0;
        int cb = (bdeg >= 0 && i <= bdeg) ? b->coeffs[i] : 0;
        result->coeffs[i] = ca + cb;
    }
    trim_poly(result);
    return result;
}
Polynomial* poly_subtract(Polynomial *a, Polynomial *b) {
    Polynomial *neg_b = poly_multiply_scalar(b, -1);
    Polynomial *result = poly_add(a, neg_b);
    poly_free(neg_b);
    return result;
}
Polynomial* poly_multiply(Polynomial *a, Polynomial *b) {
    if (a->degree < 0 || b->degree < 0) {
        return poly_from_number(0);
    }
    int new_degree = a->degree + b->degree;
    Polynomial *result = malloc(sizeof(Polynomial));
    result->capacity = new_degree + 1;
    result->coeffs = calloc(result->capacity, sizeof(int));
    for (int i = 0; i <= a->degree; i++) {
        for (int j = 0; j <= b->degree; j++) {
            result->coeffs[i + j] += a->coeffs[i] * b->coeffs[j];
        }
    }
    result->degree = new_degree;
    trim_poly(result);
    return result;
}
Polynomial* poly_multiply_scalar(Polynomial *p, int scalar) {
    if (p->degree < 0) {
        return poly_from_number(0);
    }
    Polynomial *result = (Polynomial *)malloc(sizeof(Polynomial));
    result->capacity = p->capacity;
    result->coeffs = (int*)calloc(result->capacity, sizeof(int));
    result->degree = p->degree;
    for (int i = 0; i <= p->degree; i++) {
        result->coeffs[i] = p->coeffs[i] * scalar;
    }
    trim_poly(result);
    return result;
}
Polynomial* poly_pow(Polynomial *base, int exp) {
    if (exp == 0) return poly_from_number(1);
    Polynomial *res = poly_from_number(1);
    for (int i = 0; i < exp; i++) {
        Polynomial *tmp = poly_multiply(res, base);
        poly_free(res);
        res = tmp;
    }
    trim_poly(res);
    return res;
}
Polynomial* copy_poly(const Polynomial *p) {
    if (!p || p->degree < 0) return poly_from_number(0);
    Polynomial *c = malloc(sizeof(Polynomial));
    *c = *p;
    c->coeffs = malloc(p->capacity * sizeof(int));
    memcpy(c->coeffs, p->coeffs, p->capacity * sizeof(int));
    return c;
}
void poly_free(Polynomial *p) {
    if (p) {
        free(p->coeffs);
        free(p);
    }
}
void poly_print(Polynomial *p) {
    if (!p || p->degree < 0) { printf("0\n"); return; }
    for (int i = p->degree; i >= 0; i--) {
        int coef = p->coeffs[i];
        if (coef == 0) continue;
        if (i != p->degree) printf(coef > 0 ? " + " : " - ");
        else if (coef < 0) printf("-");
        int c = abs(coef);
        if (i == 0 || c != 1) printf("%d", c);
        if (i > 0) printf("x");
        if (i > 1) printf("^%d", i);
    }
    printf("\n");
}