%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAX_POLYNOMIALS 100

typedef struct {
    double *coeffs;    // Массив коэффициентов: coeffs[0] = свободный член, coeffs[1] = x, coeffs[2] = x^2 и т.д.
    int degree;        // Максимальная степень
    int capacity;      // Размер выделенной памяти
} Polynomial;

typedef struct {
    char name;                    // Имя полинома (a-z)
    Polynomial *poly;            // Указатель на полином
    int is_defined;              // Флаг, определен ли полином
} NamedPolynomial;

typedef struct {
    char name;           // Имя переменной ('x', 'y', 'z' и т.д.)
} Variable;

NamedPolynomial poly_vars[MAX_POLYNOMIALS];  // Глобальный массив для простоты

extern int yylex();
extern int yyerror(char *s);
extern FILE *yyin;
extern int yylineno;

// Прототипы функций
Polynomial* poly_from_number(double num);
Polynomial* poly_from_var_power(int power);
Polynomial* poly_add(Polynomial *a, Polynomial *b);
Polynomial* poly_subtract(Polynomial *a, Polynomial *b);
Polynomial* poly_multiply(Polynomial *a, Polynomial *b);
Polynomial* poly_multiply_scalar(Polynomial *p, double scalar);
void poly_free(Polynomial *p);
void poly_print(Polynomial *p);
%}

%union {
    double num;
    char var;
}

%token <num> NUMBER
%token <var> VAR POLYVAR
%token PLUS MINUS TIMES POWER LPAREN RPAREN ASSIGN PRINT SEMI COMMENT EOL IMPLICIT_MUL UMINUS

%left PLUS MINUS
%left TIMES IMPLICIT_MUL
%right POWER
%right UMINUS

%start program

%%
program: /* empty */
    | program statement
    | program statement EOL
    | program EOL  /* Пустые строки */
;

statement: assignment
    | print_stmt  
    | expr        /* Вычисляет и печатает */
    | COMMENT     /* Игнорируется */
;

assignment: POLYVAR ASSIGN expr SEMI
    | POLYVAR ASSIGN expr  /* Без точки с запятой */
;

print_stmt: PRINT expr SEMI
    | PRINT expr  /* Без точки с запятой */
;

expr: expr PLUS expr
    | expr MINUS expr
    | expr TIMES expr
    | expr POWER NUMBER
    | LPAREN expr RPAREN
    | MINUS expr %prec UMINUS
    | NUMBER
    | VAR
    | POLYVAR
    | NUMBER VAR %prec IMPLICIT_MUL
    | NUMBER LPAREN expr RPAREN %prec IMPLICIT_MUL
    | VAR LPAREN expr RPAREN %prec IMPLICIT_MUL
;

%%

int yyerror(char *s) {
    fprintf(stderr, "Line %d: %s\n", yylineno, s);
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
    return 0;
}

/* Создание полинома из числа */
Polynomial* poly_from_number(double num) {
    Polynomial *p = malloc(sizeof(Polynomial));
    p->coeffs = calloc(1, sizeof(double));  // Начинаем с степени 0
    p->coeffs[0] = num;
    p->degree = 0;
    p->capacity = 1;
    return p;
}

/* Создание полинома из переменной со степенью */
Polynomial* poly_from_var_power(int power) {
    Polynomial *p = malloc(sizeof(Polynomial));
    p->capacity = power + 1;
    p->coeffs = calloc(p->capacity, sizeof(double));
    p->coeffs[power] = 1.0;  // Коэффициент при x^power = 1
    p->degree = power;
    return p;
}

/* Сложение полиномов (основная операция упрощения) */
Polynomial* poly_add(Polynomial *a, Polynomial *b) {
    int max_degree = (a->degree > b->degree) ? a->degree : b->degree;
    Polynomial *result = malloc(sizeof(Polynomial));
    result->capacity = max_degree + 1;
    result->coeffs = calloc(result->capacity, sizeof(double));
    result->degree = 0;
    
    // Складываем коэффициенты
    for (int i = 0; i <= max_degree; i++) {
        double coeff_a = (i <= a->degree) ? a->coeffs[i] : 0.0;
        double coeff_b = (i <= b->degree) ? b->coeffs[i] : 0.0;
        result->coeffs[i] = coeff_a + coeff_b;
        if (result->coeffs[i] != 0.0) {
            result->degree = i;  // Обновляем максимальную степень
        }
    }
    
    return result;
}

/* Вычитание полиномов */
Polynomial* poly_subtract(Polynomial *a, Polynomial *b) {
    // Аналогично сложению, но с отрицанием b
    Polynomial *neg_b = poly_multiply_scalar(b, -1.0);
    Polynomial *result = poly_add(a, neg_b);
    poly_free(neg_b);
    return result;
}

/* Умножение полиномов */
Polynomial* poly_multiply(Polynomial *a, Polynomial *b) {
    int new_degree = a->degree + b->degree;
    Polynomial *result = malloc(sizeof(Polynomial));
    result->capacity = new_degree + 1;
    result->coeffs = calloc(result->capacity, sizeof(double));
    result->degree = 0;
    
    // Умножение по схеме свертки
    for (int i = 0; i <= a->degree; i++) {
        for (int j = 0; j <= b->degree; j++) {
            result->coeffs[i + j] += a->coeffs[i] * b->coeffs[j];
        }
    }
    
    // Находим новую максимальную степень
    for (int i = new_degree; i >= 0; i--) {
        if (result->coeffs[i] != 0.0) {
            result->degree = i;
            break;
        }
    }
    
    return result;
}

/* Умножение полинома на скаляр */
Polynomial* poly_multiply_scalar(Polynomial *p, double scalar) {
    Polynomial *result = malloc(sizeof(Polynomial));
    result->capacity = p->capacity;
    result->coeffs = calloc(result->capacity, sizeof(double));
    result->degree = p->degree;

    for (int i = 0; i <= p->degree; i++) {
        result->coeffs[i] = p->coeffs[i] * scalar;
    }

    return result;
}

/* Освобождение памяти полинома */
void poly_free(Polynomial *p) {
    if (p) {
        free(p->coeffs);
        free(p);
    }
}

/* Вывод полинома */
void poly_print(Polynomial *p) {
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
                printf("%.2f", abs_coeff);
            } else if (i == 1) {
                if (abs_coeff != 1.0) {
                    printf("%.2fx", abs_coeff);
                } else {
                    printf("x");
                }
            } else {
                if (abs_coeff != 1.0) {
                    printf("%.2fx^%d", abs_coeff, i);
                } else {
                    printf("x^%d", i);
                }
            }
            first = 0;
        }
    }
    if (first) printf("0");
    printf("\n");
}