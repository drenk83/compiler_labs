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
%token DOLLAR_ID DOLLAR_NUM DOLLAR_SPECIAL DOLLAR_BRACE DOLLAR_LPAREN ARITH
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

/* последовательность команд */
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
    | nl_opt NL
    ;

and_or:
    pipeline
    | and_or AND nl_opt pipeline
    | and_or OR nl_opt pipeline
    ;

/* конвейер | */
pipeline:
    command
    | pipeline PIPE nl_opt command
    ;

command:
    simple_command
    | test_command
    | compound_command
    | function_def redir_list
    | local_stmt
    | stray_keyword
    ;

simple_command:
    assign_list
    | assign_list word arg_list redir_list
    | word arg_list redir_list
    ;

/* [ ... ]; [[ ... ]] - нельзя */
test_command:
    LBRACK arg_list RBRACK redir_list
    | LBRACK LBRACK {
        error_line(yylineno, "[[ ... ]] is not supported");
        exit(1);
    }
    ;

/* составная команда и редиректы */
compound_command:
    compound_head redir_list
    ;

assign_part:
    ASSIGN
    | ASSIGN LPAREN arg_list RPAREN
    ;

assign_list:
    assign_part
    | assign_list assign_part
    ;

arg_list:
    | arg_list arg
    ;

arg:
    word
    | assign_part
    | LBRACE WORD RBRACE
    ;

compound_head:
    if_clause
    | while_clause
    | until_clause
    | for_clause
    | select_clause
    | case_clause
    | brace_group
    | subshell
    ;

/* ( команды ) */
subshell:
    LPAREN list RPAREN
    ;

word:
    ID
    | WORD
    | STRING
    | expansion
    ;

/* $имя, $1, ${имя}, $# $@ $* $$ $? */
expansion:
    DOLLAR_ID
    | DOLLAR_NUM
    | DOLLAR_SPECIAL
    | DOLLAR_BRACE
    | cmdsubst
    | ARITH
    ;

/* $(...) */
cmdsubst:
    DOLLAR_LPAREN list RPAREN
    ;

redir_list:
    | redir_list redir
    ;

/* > >> < 2> 2>&1; << нельзя here-документ */
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
    word
    ;

if_clause:
    IF nl_opt and_or sep THEN list FI
    | IF nl_opt and_or sep THEN list elif_parts FI
    | IF nl_opt and_or sep THEN list ELSE list FI
    | IF nl_opt and_or sep THEN list elif_parts ELSE list FI
    | IF nl_opt and_or THEN {
        error_line(yylineno, "missing ';' or newline before then");
        exit(1);
    }
    ;

elif_parts:
    ELIF nl_opt and_or sep THEN list
    | elif_parts ELIF nl_opt and_or sep THEN list
    | ELIF nl_opt and_or THEN {
        error_line(yylineno, "missing ';' or newline before then");
        exit(1);
    }
    ;

while_clause:
    WHILE nl_opt and_or sep DO list DONE
    | WHILE nl_opt and_or DO {
        error_line(yylineno, "missing ';' or newline before do");
        exit(1);
    }
    ;

until_clause:
    UNTIL nl_opt and_or sep DO list DONE
    | UNTIL nl_opt and_or DO {
        error_line(yylineno, "missing ';' or newline before do");
        exit(1);
    }
    ;

for_clause:
    FOR ID IN arg_list sep DO list DONE
    | FOR ID sep DO list DONE
    | FOR ID DO list DONE
    | FOR LPAREN LPAREN for_c_style RPAREN RPAREN sep DO list DONE
    | FOR LPAREN LPAREN for_c_style RPAREN RPAREN DO list DONE
    | FOR ID IN arg_list DO {
        error_line(yylineno, "missing ';' or newline before do");
        exit(1);
    }
    ;

/* i=0; i<10; i++ */
for_c_style:
    | for_c_style for_part
    ;

for_part:
    ID
    | WORD
    | ASSIGN
    | SEMI
    | DSEMI
    | LT
    | GT
    ;

select_clause:
    SELECT ID IN arg_list sep DO list DONE
    | SELECT ID sep DO list DONE
    | SELECT ID DO list DONE
    | SELECT ID IN arg_list DO {
        error_line(yylineno, "missing ';' or newline before do");
        exit(1);
    }
    ;

sep:
    SEMI nl_opt
    | NL nl_opt
    ;

case_clause:
    CASE arg IN nl_opt case_items ESAC
    | CASE arg ESAC {
        error_line(yylineno, "case requires in");
        exit(1);
    }
    | CASE arg SEMI {
        error_line(yylineno, "case requires in");
        exit(1);
    }
    | CASE arg NL {
        error_line(yylineno, "case requires in");
        exit(1);
    }
    ;

case_items:
    | case_items case_item
    ;

/* a|b|c) echo x ;; */
case_item:
    patterns RPAREN list DSEMI nl_opt
    | patterns RPAREN list ESAC {
        error_line(yylineno, "case item must end with ;;");
        exit(1);
    }
    ;

/* a|b|c */
patterns:
    pattern
    | patterns PIPE pattern
    ;

pattern:
    ID
    | WORD
    | STRING
    ;

/* name(), function name, function name() */
function_def:
    ID LPAREN RPAREN nl_opt brace_group
    | FUNCTION ID nl_opt brace_group
    | FUNCTION ID LPAREN RPAREN nl_opt brace_group
    ;

/* { }; перед } нужен ; или перевод строки */
brace_group:
    LBRACE nl_opt RBRACE
    | LBRACE nl_opt stmt_seq separator RBRACE
    | LBRACE nl_opt stmt_seq RBRACE {
        error_line(yylineno, "missing ';' or newline before '}'");
        exit(1);
    }
    ;

/* then или do не на месте */
stray_keyword:
    THEN {
        error_line(yylineno, "unexpected then");
        exit(1);
    }
    | DO {
        error_line(yylineno, "unexpected do");
        exit(1);
    }
    ;

/* local */
local_stmt:
    LOCAL local_names
    ;

local_names:
    local_item
    | local_names local_item
    ;

local_item:
    ID
    | WORD
    | ASSIGN
    | ASSIGN local_value
    | ASSIGN LPAREN arg_list RPAREN
    ;

local_value:
    STRING
    | expansion
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
