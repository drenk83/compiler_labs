%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "poly.h"
NamedPolynomial poly_vars[MAX_POLYNOMIALS];
extern int yylex();
extern int yyerror(char *s);
extern FILE *yyin;
extern int yylineno;
// Прототипы (уже в poly.h, но для ясности)
%}
%union {
    double num;
    char var;
    AST ast;
}
%type <ast> expr addexpr mulexpr power unary primary
%token <num> NUMBER
%token <var> VAR POLYVAR
%token PLUS MINUS TIMES POWER LPAREN RPAREN ASSIGN PRINT SEMI COMMENT EOL IMPLICIT_MUL NEG
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
         | COMMENT { /* ignore */ }
         ;
assignment: POLYVAR ASSIGN expr SEMI {
             char name = $1;
             int idx = name - 'a';
             if (idx < 0 || idx >= MAX_POLYNOMIALS) {
                 fprintf(stderr, "Line %d: Semantic error: Invalid polyvar '%c'\n", yylineno, name);
             } else {
                 Polynomial *newp = eval_ast($3);
                 if (newp) {
                     if (poly_vars[idx].poly) poly_free(poly_vars[idx].poly);
                     poly_vars[idx].poly = newp;
                     poly_vars[idx].is_defined = 1;
                     poly_vars[idx].name = name;
                 }
                 ast_free($3);
             }
           }
         | POLYVAR ASSIGN expr {
             char name = $1;
             int idx = name - 'a';
             if (idx < 0 || idx >= MAX_POLYNOMIALS) {
                 fprintf(stderr, "Line %d: Semantic error: Invalid polyvar '%c'\n", yylineno, name);
             } else {
                 Polynomial *newp = eval_ast($3);
                 if (newp) {
                     if (poly_vars[idx].poly) poly_free(poly_vars[idx].poly);
                     poly_vars[idx].poly = newp;
                     poly_vars[idx].is_defined = 1;
                     poly_vars[idx].name = name;
                 }
                 ast_free($3);
             }
           }
         ;
print_stmt: PRINT expr SEMI {
             Polynomial *p = eval_ast($2);
             if (p) {
                 poly_print(p);
                 poly_free(p);
             }
             ast_free($2);
           }
          | PRINT expr {
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
       | addexpr PLUS mulexpr { $$ = ast_create_binop(AST_ADD, $1, $3); }
       | addexpr MINUS mulexpr { $$ = ast_create_binop(AST_SUB, $1, $3); }
       ;
mulexpr: power { $$ = $1; }
       | mulexpr TIMES power { $$ = ast_create_binop(AST_MUL, $1, $3); }
       | mulexpr power %prec IMPLICIT_MUL { $$ = ast_create_binop(AST_MUL, $1, $2); }
       ;
power: unary %prec POWER { $$ = $1; }
     | unary POWER power { $$ = ast_create_binop(AST_POW, $1, $3); }
     ;
unary: primary { $$ = $1; }
     | MINUS power %prec UMINUS { $$ = ast_create_unop(AST_UMINUS, $2); }
     ;
primary: NUMBER { $$ = ast_create_num($1); }
       | VAR { $$ = ast_create_var($1); }
       | POLYVAR { $$ = ast_create_polyvar($1); }
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
    for (int i = 0; i < MAX_POLYNOMIALS; i++) {
        poly_vars[i].name = 0;
        poly_vars[i].poly = NULL;
        poly_vars[i].is_defined = 0;
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
AST ast_create_num(double n) {
    AST node = (AST)malloc(sizeof(struct ASTNode));
    node->type = AST_NUM;
    node->line = yylineno;
    node->left = node->right = NULL;
    node->u.num = n;
    return node;
}
AST ast_create_var(char v) {
    AST node = (AST)malloc(sizeof(struct ASTNode));
    node->type = AST_VAR;
    node->line = yylineno;
    node->left = node->right = NULL;
    node->u.var_name = v;
    return node;
}
AST ast_create_polyvar(char p) {
    AST node = (AST)malloc(sizeof(struct ASTNode));
    node->type = AST_POLYVAR;
    node->line = yylineno;
    node->left = node->right = NULL;
    node->u.poly_name = p;
    return node;
}
AST ast_create_binop(ASTType op, AST l, AST r) {
    AST node = (AST)malloc(sizeof(struct ASTNode));
    node->type = op;
    node->line = yylineno;
    node->left = l;
    node->right = r;
    return node;
}
AST ast_create_unop(ASTType op, AST c) {
    return ast_create_binop(op, c, NULL);
}
void ast_free(AST node) {
    if (!node) return;
    ast_free(node->left);
    ast_free(node->right);
    free(node);
}
void trim_poly(Polynomial *p) {
    if (!p || p->degree < 0) return;
    while (p->degree > 0 && p->coeffs[p->degree] == 0.0) {
        p->degree--;
    }
    if (p->degree == 0 && p->coeffs[0] == 0.0) {
        p->degree = -1;
    }
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
                return poly_from_number(0.0);
            }
            return copy_poly(poly_vars[idx].poly);
        }
        case AST_ADD: {
            Polynomial *a = eval_ast(node->left);
            Polynomial *b = eval_ast(node->right);
            Polynomial *res = poly_add(a, b);
            poly_free(a);
            poly_free(b);
            trim_poly(res);
            return res;
        }
        case AST_SUB: {
            Polynomial *a = eval_ast(node->left);
            Polynomial *b = eval_ast(node->right);
            Polynomial *res = poly_subtract(a, b);
            poly_free(a);
            poly_free(b);
            trim_poly(res);
            return res;
        }
        case AST_MUL: {
            Polynomial *a = eval_ast(node->left);
            Polynomial *b = eval_ast(node->right);
            Polynomial *res = poly_multiply(a, b);
            poly_free(a);
            poly_free(b);
            trim_poly(res);
            return res;
        }
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
                return poly_from_number(0.0);
            }
            double pd = exp_poly->coeffs[0];
            poly_free(exp_poly);
            int exp = (int)pd;
            if (floor(pd) != pd || exp < 0) {
                fprintf(stderr, "Line %d: Semantic error: Power must be non-negative integer, got %g\n",
                        node->line, pd);
                poly_free(base);
                return poly_from_number(0.0);
            }
            Polynomial *res = poly_pow(base, exp);
            poly_free(base);
            trim_poly(res);
            return res;
        }
        case AST_UMINUS: {
            Polynomial *c = eval_ast(node->left);
            Polynomial *res = poly_multiply_scalar(c, -1.0);
            poly_free(c);
            trim_poly(res);
            return res;
        }
        default:
            fprintf(stderr, "Line %d: Semantic error: Unknown AST type\n", node->line);
            return poly_from_number(0.0);
    }
}
/* Poly functions (updated with trim) */
Polynomial* poly_from_number(double num) {
    Polynomial *p = (Polynomial *)malloc(sizeof(Polynomial));
    p->coeffs = (double*)calloc(1, sizeof(double));
    p->coeffs[0] = num;
    p->degree = (num != 0.0) ? 0 : -1;
    p->capacity = 1;
    return p;
}
Polynomial* poly_from_var_power(int power) {
    Polynomial *p = (Polynomial *)malloc(sizeof(Polynomial));
    p->capacity = power + 1;
    p->coeffs = (double*)calloc(p->capacity, sizeof(double));
    p->coeffs[power] = 1.0;
    p->degree = power;
    return p;
}
Polynomial* poly_add(Polynomial *a, Polynomial *b) {
    int adeg = a->degree < 0 ? -1 : a->degree;
    int bdeg = b->degree < 0 ? -1 : b->degree;
    int max_degree = (adeg > bdeg) ? adeg : bdeg;
    if (max_degree < 0) {
        return poly_from_number(0.0);
    }
    Polynomial *result = (Polynomial *)malloc(sizeof(Polynomial));
    result->capacity = max_degree + 1;
    result->coeffs = (double*)calloc(result->capacity, sizeof(double));
    result->degree = -1;
    for (int i = 0; i <= max_degree; i++) {
        double ca = (adeg >= 0 && i <= adeg) ? a->coeffs[i] : 0.0;
        double cb = (bdeg >= 0 && i <= bdeg) ? b->coeffs[i] : 0.0;
        result->coeffs[i] = ca + cb;
        if (result->coeffs[i] != 0.0) {
            result->degree = i;
        }
    }
    trim_poly(result);
    return result;
}
Polynomial* poly_subtract(Polynomial *a, Polynomial *b) {
    Polynomial *neg_b = poly_multiply_scalar(b, -1.0);
    Polynomial *result = poly_add(a, neg_b);
    poly_free(neg_b);
    return result;
}
Polynomial* poly_multiply(Polynomial *a, Polynomial *b) {
    if (a->degree < 0 || b->degree < 0) {
        return poly_from_number(0.0);
    }
    int new_degree = a->degree + b->degree;
    Polynomial *result = (Polynomial *)malloc(sizeof(Polynomial));
    result->capacity = new_degree + 1;
    result->coeffs = (double*)calloc(result->capacity, sizeof(double));
    for (int i = 0; i <= a->degree; i++) {
        for (int j = 0; j <= b->degree; j++) {
            result->coeffs[i + j] += a->coeffs[i] * b->coeffs[j];
        }
    }
    result->degree = -1;
    for (int i = new_degree; i >= 0; i--) {
        if (result->coeffs[i] != 0.0) {
            result->degree = i;
            break;
        }
    }
    trim_poly(result);
    return result;
}
Polynomial* poly_multiply_scalar(Polynomial *p, double scalar) {
    if (p->degree < 0) {
        return poly_from_number(0.0);
    }
    Polynomial *result = (Polynomial *)malloc(sizeof(Polynomial));
    result->capacity = p->capacity;
    result->coeffs = (double*)calloc(result->capacity, sizeof(double));
    result->degree = p->degree;
    for (int i = 0; i <= p->degree; i++) {
        result->coeffs[i] = p->coeffs[i] * scalar;
    }
    trim_poly(result);
    return result;
}
Polynomial* poly_pow(Polynomial *base, int exp) {
    if (exp == 0) return poly_from_number(1.0);
    Polynomial *res = poly_from_number(1.0);
    for (int i = 0; i < exp; i++) {
        Polynomial *tmp = poly_multiply(res, base);
        poly_free(res);
        res = tmp;
    }
    trim_poly(res);
    return res;
}
Polynomial* copy_poly(const Polynomial *p) {
    if (!p || p->degree < 0) return poly_from_number(0.0);
    Polynomial *c = (Polynomial *)malloc(sizeof(Polynomial));
    c->degree = p->degree;
    c->capacity = p->capacity;
    c->coeffs = (double*)malloc(p->capacity * sizeof(double));
    memcpy(c->coeffs, p->coeffs, p->capacity * sizeof(double));
    return c;
}
void poly_free(Polynomial *p) {
    if (p) {
        free(p->coeffs);
        free(p);
    }
}
void poly_print(Polynomial *p) {
    if (!p || p->degree < 0) {
        printf("0\n");
        return;
    }
    int first = 1;
    for (int i = p->degree; i >= 0; i--) {
        if (p->coeffs[i] != 0.0) {
            if (!first) {
                printf(p->coeffs[i] > 0 ? " + " : " - ");
            } else if (p->coeffs[i] < 0) {
                printf("-");
            }
            double abs_coeff = fabs(p->coeffs[i]);
            if (i == 0) {
                printf("%.0f", abs_coeff);
            } else if (i == 1) {
                if (fabs(abs_coeff - 1.0) > 1e-9) printf("%.0fx", abs_coeff);
                else printf("x");
            } else {
                if (fabs(abs_coeff - 1.0) > 1e-9) printf("%.0fx^%d", abs_coeff, i);
                else printf("x^%d", i);
            }
            first = 0;
        }
    }
    if (first) printf("0");
    printf("\n");
}