%{
#include <stdio.h>
#include "y.tab.h"
extern int yylex(void);
extern int yylineno;
extern FILE *yyin;
void yyerror(char *s) {
    fprintf(stderr, "Syntax error: %s (line %d)\n", s, yylineno);
}
%}
%token IF THEN ELIF ELSE FI TIME FOR IN UNTIL WHILE DO DONE CASE ESAC COPROC SELECT FUNCTION
%token EQUAL PIPE AMP SEMI LT GT BANG DOLLAR DOLLAR_BRACED
%token LBRACE RBRACE LPAREN RPAREN LDBRACKET RDBRACKET
%token ID STRING NUMBER SHEBANG
%token WS NEWLINE

%start script

%%
script: /* empty */
    | SHEBANG
    | SHEBANG NEWLINE statements
    ;
statements: /* empty */
    | statements command_list
    ;
command_list:
    | command_list NEWLINE
    | assignment
    ;
assignment: ID EQUAL
    | ID EQUAL arg
    ;
arg: ID
    | NUMBER
    | STRING
    | DOLLAR ID
    | DOLLAR_BRACED
    | array
    ;
array: LPAREN ws_list RPAREN
    | LPAREN ws_list elements ws_list RPAREN
    ;
elements: arg
    | elements WS arg
    ;
ws_list: /* empty */
        | ws_list WS
        ;
%%
int main(int argc, char **argv) {
    FILE *input = NULL;
    if (argc > 1) {
        input = fopen(argv[1], "r");
        if (!input) {
            perror("Error opening file");
            return 1;
        }
        yyin = input;
    }
    int result = yyparse();
    if (input) {
        fclose(input);
    }
    return result;
}