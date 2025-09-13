#ifndef POLY_H
#define POLY_H
#include <math.h>  // Для fabs, floor
typedef struct {
    double *coeffs; // coeffs[0] = const, [1]=x, [2]=x^2, ...
    int degree;
    int capacity;
} Polynomial;
typedef struct {
    char name; // 'a'..'z'
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
        double num;
        char var_name;
        char poly_name;
    } u;
} *AST;  // Теперь AST — указатель на struct ASTNode
#define MAX_POLYNOMIALS 26  // a-z
// Декларации
Polynomial* poly_from_number(double num);
Polynomial* poly_from_var_power(int power);
Polynomial* poly_add(Polynomial *a, Polynomial *b);
Polynomial* poly_subtract(Polynomial *a, Polynomial *b);
Polynomial* poly_multiply(Polynomial *a, Polynomial *b);
Polynomial* poly_multiply_scalar(Polynomial *p, double scalar);
Polynomial* poly_pow(Polynomial *base, int exp);
Polynomial* copy_poly(const Polynomial *p);
void poly_free(Polynomial *p);
void poly_print(Polynomial *p);
AST ast_create_num(double n);
AST ast_create_var(char v);
AST ast_create_polyvar(char p);
AST ast_create_binop(ASTType op, AST l, AST r);
AST ast_create_unop(ASTType op, AST c);
Polynomial* eval_ast(AST node);
void ast_free(AST node);
void trim_poly(Polynomial *p);
extern NamedPolynomial poly_vars[MAX_POLYNOMIALS];
#endif