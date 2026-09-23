%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
extern int yylineno;
extern FILE *yyin;

void error_line(int line, const char *msg)
{
    if (msg)
        fprintf(stderr, "Error: line %d: %s\n", line, msg);
    else
        fprintf(stderr, "Error: line %d\n", line);
}

void yyerror(char *msg)
{
    (void)msg;
    error_line(yylineno, NULL);
}
%}

%token SHEBANG
%token IF THEN ELIF ELSE FI
%token WHILE UNTIL DO DONE
%token FOR SELECT IN CASE ESAC FUNCTION LOCAL
%token ID WORD STRING ASSIGN
%token DOLLAR_ID DOLLAR_NUM DOLLAR_SPECIAL DOLLAR_BRACE DOLLAR_LPAREN
%token LBRACK RBRACK LBRACE RBRACE LPAREN RPAREN
%token PIPE AND OR AMP SEMI DSEMI NL
%token LT GT DGREAT REDIR_ERR REDIR_ERR_OUT

%start program

%%

program:
    SHEBANG list
    ;

list:
    nl_opt
    | nl_opt stmt_seq
    | nl_opt stmt_seq separator
    ;

stmt_seq:
    and_or
    | stmt_seq separator and_or
    ;

separator:
    SEMI nl_opt
    | AMP nl_opt
    | NL nl_opt
    ;

nl_opt:
    /* empty */
    | nl_opt NL
    ;

and_or:
    pipeline
    | and_or AND nl_opt pipeline
    | and_or OR nl_opt pipeline
    ;

pipeline:
    command
    | pipeline PIPE nl_opt command
    ;

command:
    simple_command
    | assignment
    | test_command
    | if_clause
    | while_clause
    | until_clause
    | for_clause
    | select_clause
    | case_clause
    | function_def
    | local_stmt
    ;

assignment:
    ASSIGN
    | ASSIGN word
    ;

simple_command:
    cmd_name arg_list redir_list
    ;

cmd_name:
    ID
    | WORD
    ;

arg_list:
    /* empty */
    | arg_list arg
    ;

arg:
    word
    | ASSIGN
    ;

word:
    ID
    | WORD
    | STRING
    | expansion
    ;

expansion:
    DOLLAR_ID
    | DOLLAR_NUM
    | DOLLAR_SPECIAL
    | DOLLAR_BRACE
    | cmdsubst
    ;

cmdsubst:
    DOLLAR_LPAREN list RPAREN
    ;

redir_list:
    /* empty */
    | redir_list redir
    ;

redir:
    GT redir_target
    | DGREAT redir_target
    | LT redir_target
    | LT LT {
        error_line(yylineno, "here-document is not supported");
        exit(1);
    }
    | REDIR_ERR redir_target
    | REDIR_ERR_OUT
    ;

redir_target:
    ID
    | WORD
    ;

test_command:
    LBRACK arg_list RBRACK
    ;

if_clause:
    IF test_command sep THEN list FI
    | IF test_command sep THEN list elif_parts FI
    | IF test_command sep THEN list ELSE list FI
    | IF test_command sep THEN list elif_parts ELSE list FI
    | IF bad_condition {
        error_line(yylineno, "if condition must be [ ... ]");
        exit(1);
    }
    ;

elif_parts:
    ELIF test_command sep THEN list
    | elif_parts ELIF test_command sep THEN list
    ;

while_clause:
    WHILE test_command sep DO list DONE
    | WHILE bad_condition {
        error_line(yylineno, "while condition must be [ ... ]");
        exit(1);
    }
    ;

until_clause:
    UNTIL test_command sep DO list DONE
    | UNTIL bad_condition {
        error_line(yylineno, "until condition must be [ ... ]");
        exit(1);
    }
    ;

/* Условие if/while/until без '[': одно слово и разделитель. */
bad_condition:
    word SEMI
    | word NL
    ;

for_clause:
    FOR ID IN arg_list sep DO list DONE
    ;

select_clause:
    SELECT ID IN arg_list sep DO list DONE
    ;

sep:
    SEMI nl_opt
    | NL nl_opt
    ;

case_clause:
    CASE arg IN nl_opt case_items ESAC
    ;

case_items:
    /* empty */
    | case_items case_item
    ;

case_item:
    patterns RPAREN list DSEMI nl_opt
    ;

patterns:
    pattern
    | patterns PIPE pattern
    ;

pattern:
    ID
    | WORD
    | STRING
    ;

function_def:
    ID LPAREN RPAREN nl_opt brace_group
    | FUNCTION ID nl_opt brace_group
    | FUNCTION ID LPAREN RPAREN nl_opt brace_group
    ;

brace_group:
    LBRACE nl_opt RBRACE
    | LBRACE nl_opt stmt_seq separator RBRACE
    ;

local_stmt:
    LOCAL local_names
    ;

local_names:
    local_item
    | local_names local_item
    ;

local_item:
    ID
    | ASSIGN
    | ASSIGN word
    ;

%%

int main(int argc, char **argv)
{
    int result;

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror(argv[1]);
            return 1;
        }
    }
    result = yyparse();
    if (argc > 1)
        fclose(yyin);
    return result;
}
