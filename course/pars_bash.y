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
%token EQUAL PIPE AMP SEMI LT GT BANG DOLLAR DOLLAR_BRACED PLUS MINUS DOT
%token LBRACE RBRACE LPAREN RPAREN LDBRACKET RDBRACKET
%token ID STRING NUMBER SHEBANG SOBAKA DOLLAR_SHARP
%token WS NEWLINE

%start script

%%
script: SHEBANG statements { printf("script \n"); }
    | statements
    ;
statements: newline_list_opt command_list newline_list_opt { printf("statements \n"); }
    ;

command_list: /* empty */
    | command_group separator_opt { printf("command_list \n"); }
    ;
command_group: pipeline { printf("command_group: pipeline \n"); }
    | command_group separator ws_opt pipeline { printf("command_group separator ws_opt pipeline \n"); }
    ;
separator: SEMI ws_opt newline_list_opt { printf("separator \n"); }
    | newline_list
    ;
newline_list: NEWLINE
    | newline_list NEWLINE
    ;
simple_command: assignment ws_opt { printf("assignment ws_opt \n"); }
    | command ws_opt { printf("command ws_opt \n"); }
    | ifelsefi ws_opt { printf("ifelsefi ws_opt \n"); }
    ;
pipeline: simple_command
    | pipeline ws_opt PIPE ws_opt simple_command
    ;
assignment: ID EQUAL
    | ID EQUAL arg
    ;
arg: ID
    | NUMBER
    | MINUS NUMBER
    | PLUS NUMBER
    | MINUS ID
    | PLUS ID
    | MINUS MINUS longid
    | ID DOT ID
    | STRING
    | with_dollar
    | array
    ;
with_dollar: DOLLAR ID
    | DOLLAR NUMBER
    | DOLLAR DOLLAR
    | DOLLAR SOBAKA
    | DOLLAR_SHARP
    | DOLLAR_BRACED
    | DOLLAR LPAREN ws_opt command ws_opt RPAREN
    ;
array: LPAREN ws_opt RPAREN
    | LPAREN ws_opt elements ws_opt RPAREN
    ;
elements: arg
    | elements WS arg
    ;
longid: ID
    | longid MINUS ID
    ;
command: longid arg_list
    ;
arg_list: /* empty */
    | arg_list WS arg
    | arg_list WS assignment
;

/* opt functions */
separator_opt: /* empty */
    | separator
    ;
newline_list_opt: /* empty */
    | newline_list
    ;
ws_opt: /* empty */
    | WS
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