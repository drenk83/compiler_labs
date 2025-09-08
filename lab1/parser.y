%{
#include <stdio.h>
int yylex();
void yyerror(char *s);
%}

%token NUMBER
%left '+' '-'
%left '*' '/'
%right '^'
%nonassoc UMINUS

%%

input: /* empty */
     | input line
;

line: '\n'
    | expr '\n' { printf("%d\n", $1); }
;

expr: expr '+' term { $$ = $1 + $3; }
    | expr '-' term { $$ = $1 - $3; }
    | term { $$ = $1; }
;

term: term '*' factor { $$ = $1 * $3; }
    | term '/' factor { $$ = $1 / $3; }
    | factor { $$ = $1; }
;

factor: NUMBER { $$ = $1; }
      | '-' factor %prec UMINUS { $$ = -$2; }
      | '(' expr ')' { $$ = $2; }
      | factor '^' factor { $$ = $1; }  /* Простая степень, без pow (для int) */
;

%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}