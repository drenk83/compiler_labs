#ifndef POLY_H
#define POLY_H

typedef struct {
    int *coeffs;
    int degree;
    int capacity;
} Polynomial;

typedef struct {
    char name; /* 'a'..'z' */
    Polynomial *poly;
    int is_defined;
} NamedPolynomial;

typedef enum {
    AST_NUM,
    AST_VAR,
    AST_POLYVAR,
    AST_ADD,
    AST_SUB,
    AST_MUL,
    AST_POW,
    AST_UMINUS
} ASTType;

typedef struct ASTNode {
    ASTType type;
    int line;
    struct ASTNode *left;
    struct ASTNode *right;
    union {
        int num;  /* Изменено с double на int */
        char var_name;
        char poly_name;
    } u;
} *AST;

#define MAX_POLYNOMIALS 26  /* a-z */

Polynomial* poly_from_number(int num);  /* double -> int */
Polynomial* poly_from_var_power(int power);
Polynomial* poly_add(Polynomial *a, Polynomial *b);
Polynomial* poly_subtract(Polynomial *a, Polynomial *b);
Polynomial* poly_multiply(Polynomial *a, Polynomial *b);
Polynomial* poly_multiply_scalar(Polynomial *p, int scalar);  /* double -> int */
Polynomial* poly_pow(Polynomial *base, int exp);
Polynomial* copy_poly(const Polynomial *p);
void poly_free(Polynomial *p);
void poly_print(Polynomial *p);

AST ast_create(ASTType type, AST left, AST right, int num, char var);  /* double -> int */
Polynomial* eval_ast(AST node);
void ast_free(AST node);
void trim_poly(Polynomial *p);

extern NamedPolynomial poly_vars[MAX_POLYNOMIALS];

#endif