%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(char *s);

extern FILE *yyin;
extern char *yytext;
%}

%option noyywrap

%x STRING

/* Reserved words */
IF      "if"
THEN    "then"
ELIF    "elif"
ELSE    "else"
FI      "fi"
TIME    "time"
FOR     "for"
IN      "in"
UNTIL   "until"
WHILE   "while"
DO      "do"
DONE    "done"
CASE    "case"
ESAC    "esac"
COPROC  "coproc"
SELECT  "select"
FUNCTION "function"
READONLY "readonly"
ECHO    "echo"
LOCAL   "local"
EXIT    "exit"
READ    "read"

/* Test operators */
GE      "-ge"
GT      "-gt"
LT      "-lt"

/* Symbols */
LBRACE  "{"
RBRACE  "}"
LBRACK  "["
RBRACK  "]"
DBL_LBRACK  "[["
DBL_RBRACK  "]]"
BANG    "!"
PIPE    "|"
AMPERSAND "&"
SEMICOLON ";"
LPAREN  "("
RPAREN  ")"
LT_SYM  "<"
GT_SYM  ">"
DOLLAR  "$"
QUOTE   "\""
ASSIGN  "="
PLUS    "+"
MINUS   "-"
MULT    "\*"
SLASH   "/"
DOTDOT  ".."
DBL_LPAREN  "(("
DBL_RPAREN  "))"

/* New for this script */
OPTION  "-[a-z]+"
COMMAND [a-zA-Z_][a-zA-Z0-9_-]*
/* Case-specific */
DOUBLE_SEMI ";;"

/* Variable assignment pattern (explicit to avoid subpattern issues) */
VAR_ASSIGN [a-zA-Z_][a-zA-Z0-9_]*=
/* Special for var=0 */
VAR_ASSIGN_ZERO [a-zA-Z_][a-zA-Z0-9_]*=0
/* Function definition: name() { (no spaces) */
FUNC_DEF [a-zA-Z_][a-zA-Z0-9_]*\(\)

/* Shebang */
SHEBANG "#!/bin/bash"
/* Comment */
COMMENT "#"[^\n]*
/* Number */
NUMBER [0-9][0-9]*(\.[0-9]+)?([eE][+-]?[0-9]+)?
/* String content (simple, non-escaped) */
STR_CONTENT [^\n\"]+
/* Other patterns: whitespace and identifiers/other chars */
IDENT [a-zA-Z_][a-zA-Z0-9_]*
WS [ \t\n\r\u00A0]+
OTHER .

%%

{FUNC_DEF} { printf("TOKEN: FUNC_DEF (%s)\n", yytext); }
{VAR_ASSIGN_ZERO} { printf("TOKEN: VAR_ASSIGN_ZERO (%s)\n", yytext); }
{NUMBER} { printf("TOKEN: NUMBER (%s)\n", yytext); }
{IF} { printf("TOKEN: IF\n"); }
{THEN} { printf("TOKEN: THEN\n"); }
{ELIF} { printf("TOKEN: ELIF\n"); }
{ELSE} { printf("TOKEN: ELSE\n"); }
{FI} { printf("TOKEN: FI\n"); }
{TIME} { printf("TOKEN: TIME\n"); }
{FOR} { printf("TOKEN: FOR\n"); }
{IN} { printf("TOKEN: IN\n"); }
{UNTIL} { printf("TOKEN: UNTIL\n"); }
{WHILE} { printf("TOKEN: WHILE\n"); }
{DO} { printf("TOKEN: DO\n"); }
{DONE} { printf("TOKEN: DONE\n"); }
{CASE} { printf("TOKEN: CASE\n"); }
{ESAC} { printf("TOKEN: ESAC\n"); }
{COPROC} { printf("TOKEN: COPROC\n"); }
{SELECT} { printf("TOKEN: SELECT\n"); }
{FUNCTION} { printf("TOKEN: FUNCTION\n"); }
{READONLY} { printf("TOKEN: READONLY\n"); }
{ECHO} { printf("TOKEN: ECHO\n"); }
{LOCAL} { printf("TOKEN: LOCAL\n"); }
{EXIT} { printf("TOKEN: EXIT\n"); }
{READ} { printf("TOKEN: READ\n"); }
{DOUBLE_SEMI} { printf("TOKEN: DOUBLE_SEMI\n"); }
{GE} { printf("TOKEN: GE\n"); }
{GT} { printf("TOKEN: GT\n"); }
{LT} { printf("TOKEN: LT\n"); }
{LBRACE} { printf("TOKEN: LBRACE\n"); }
{RBRACE} { printf("TOKEN: RBRACE\n"); }
{LBRACK} { printf("TOKEN: LBRACK\n"); }
{RBRACK} { printf("TOKEN: RBRACK\n"); }
{DBL_LBRACK} { printf("TOKEN: DBL_LBRACK\n"); }
{DBL_RBRACK} { printf("TOKEN: DBL_RBRACK\n"); }
{BANG} { printf("TOKEN: BANG\n"); }
{PIPE} { printf("TOKEN: PIPE\n"); }
{AMPERSAND} { printf("TOKEN: AMPERSAND\n"); }
{SEMICOLON} { printf("TOKEN: SEMICOLON\n"); }
{LPAREN} { printf("TOKEN: LPAREN\n"); }
{RPAREN} { printf("TOKEN: RPAREN\n"); }
{LT_SYM} { printf("TOKEN: LT_SYM\n"); }
{GT_SYM} { printf("TOKEN: GT_SYM\n"); }
{DOLLAR} { printf("TOKEN: DOLLAR\n"); }
{QUOTE} { BEGIN(STRING); printf("TOKEN: QUOTE\n"); }
{ASSIGN} { printf("TOKEN: ASSIGN\n"); }
{PLUS} { printf("TOKEN: PLUS\n"); }
{MINUS} { printf("TOKEN: MINUS\n"); }
{MULT} { printf("TOKEN: MULT\n"); }
{SLASH} { printf("TOKEN: SLASH\n"); }
{DOTDOT} { printf("TOKEN: DOTDOT\n"); }
{DBL_LPAREN} { printf("TOKEN: DBL_LPAREN\n"); }
{DBL_RPAREN} { printf("TOKEN: DBL_RPAREN\n"); }
{VAR_ASSIGN} { printf("TOKEN: VAR_ASSIGN (%s)\n", yytext); }
{SHEBANG} { printf("TOKEN: SHEBANG\n"); }
{COMMENT} { printf("TOKEN: COMMENT (%s)\n", yytext); }
<STRING>{QUOTE} { BEGIN(INITIAL); printf("TOKEN: QUOTE\n"); }
<STRING>{STR_CONTENT} { printf("TOKEN: STRING_CONTENT (%s)\n", yytext); }
<STRING>\n { printf("TOKEN: STRING_UNTERMINATED\n"); BEGIN(INITIAL); }
{WS} { /* ignore whitespace */ }
{IDENT} { printf("TOKEN: IDENT (%s)\n", yytext); }
{OTHER} { printf("TOKEN: OTHER (%s)\n", yytext); }
{OPTION} { printf("TOKEN: OPTION (%s)\n", yytext); }
{COMMAND} { printf("TOKEN: COMMAND (%s)\n", yytext); }

%%

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        exit(1);
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("fopen");
        exit(1);
    }

    yyin = input_file;
    yylex();
    fclose(input_file);
    return 0;
}

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}