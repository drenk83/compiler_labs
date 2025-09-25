%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h" /* Для токенов из Bison */
int yylex(void);
void yyerror(char *s);
extern FILE *yyin;
extern char *yytext;
%}
%option noyywrap
%x STRING
/* Reserved words */
IF "if"
THEN "then"
ELIF "elif"
ELSE "else"
FI "fi"
TIME "time"
FOR "for"
IN "in"
UNTIL "until"
WHILE "while"
DO "do"
DONE "done"
CASE "case"
ESAC "esac"
COPROC "coproc"
SELECT "select"
FUNCTION "function"
READONLY "readonly"
ECHO "echo"
LOCAL "local"
EXIT "exit"
READ "read"
/* Reserved commands */
LS "ls"
PWD "pwd"
CD "cd"
MKDIR "mkdir"
TOUCH "touch"
CP "cp"
MV "mv"
RM "rm"
CAT "cat"
/* Test operators */
GE "-ge"
GT "-gt"
LT "-lt"
/* Symbols */
LBRACE "{"
RBRACE "}"
LBRACK "["
RBRACK "]"
DBL_LBRACK "[["
DBL_RBRACK "]]"
BANG "!"
PIPE "|"
AMPERSAND "&"
SEMICOLON ";"
LPAREN "("
RPAREN ")"
LT_SYM "<"
GT_SYM ">"
DOLLAR "$"
QUOTE "\""
ASSIGN "="
PLUS "+"
MINUS "-"
MULT "\*"
DIV "/"
DOTDOT ".."
DBL_LPAREN "(("
DBL_RPAREN "))"
/* Case-specific */
DOUBLE_SEMI ";;"
/* Variable assignment pattern (explicit to avoid subpattern issues) */
VAR_ASSIGN [a-zA-Z_][a-zA-Z0-9_]*=
/* Special for var=0 */
VAR_ASSIGN_ZERO [a-zA-Z_][a-zA-Z0-9_]*=0
/* Function definition: name() { (no spaces) */
FUNC_DEF [a-zA-Z_][a-zA-Z0-9_]*\(\)
/* Options */
OPTION "-[a-z]+"
/* Shebang */
SHEBANG "#!/bin/bash"
/* Comment */
COMMENT "#"[^\n]*
/* Number */
NUMBER [0-9][0-9]*(\.[0-9]+)?([eE][+-]?[0-9]+)?
/* String content (simple, non-escaped) */
STR_CONTENT [^\n\"]+
/* Other patterns: whitespace and identifiers/other chars */
IDENT [a-zA-Z_\/][a-zA-Z0-9_\/.-]*
WS [ \t\r\u00A0]+
OTHER .
%%
{FUNC_DEF} { yylval.str = strdup(yytext); return FUNC_DEF; }
{VAR_ASSIGN_ZERO} { yylval.str = strdup(yytext); return VAR_ASSIGN_ZERO; }
{NUMBER} { yylval.str = strdup(yytext); return NUMBER; }
{IF} { return IF; }
{THEN} { return THEN; }
{ELIF} { return ELIF; }
{ELSE} { return ELSE; }
{FI} { return FI; }
{TIME} { return TIME; }
{FOR} { return FOR; }
{IN} { return IN; }
{UNTIL} { return UNTIL; }
{WHILE} { return WHILE; }
{DO} { return DO; }
{DONE} { return DONE; }
{CASE} { return CASE; }
{ESAC} { return ESAC; }
{COPROC} { return COPROC; }
{SELECT} { return SELECT; }
{FUNCTION} { return FUNCTION; }
{READONLY} { return READONLY; }
{ECHO} { return ECHO; }
{LOCAL} { return LOCAL; }
{EXIT} { return EXIT; }
{READ} { return READ; }
{DOUBLE_SEMI} { return DOUBLE_SEMI; }
{GE} { yylval.str = strdup(yytext); return GE; }
{GT} { yylval.str = strdup(yytext); return GT; }
{LT} { yylval.str = strdup(yytext); return LT; }
{LS} { return LS; }
{PWD} { return PWD; }
{CD} { return CD; }
{MKDIR} { return MKDIR; }
{TOUCH} { return TOUCH; }
{CP} { return CP; }
{MV} { return MV; }
{RM} { return RM; }
{CAT} { return CAT; }
{LBRACE} { return LBRACE; }
{RBRACE} { return RBRACE; }
{LBRACK} { return LBRACK; }
{RBRACK} { return RBRACK; }
{DBL_LBRACK} { return DBL_LBRACK; }
{DBL_RBRACK} { return DBL_RBRACK; }
{BANG} { return BANG; }
{PIPE} { return PIPE; }
{AMPERSAND} { return AMPERSAND; }
{SEMICOLON} { return SEMICOLON; }
{LPAREN} { return LPAREN; }
{RPAREN} { return RPAREN; }
{LT_SYM} { return LT_SYM; }
{GT_SYM} { return GT_SYM; }
{DOLLAR} { return DOLLAR; }
{QUOTE} { BEGIN(STRING); return QUOTE; }
{ASSIGN} { return ASSIGN; }
{PLUS} { return PLUS; }
{OPTION} { yylval.str = strdup(yytext); return OPTION; }
{MINUS} { return MINUS; }
{MULT} { return MULT; }
{DIV} { return DIV; }
{DOTDOT} { return DOTDOT; }
{DBL_LPAREN} { return DBL_LPAREN; }
{DBL_RPAREN} { return DBL_RPAREN; }
{VAR_ASSIGN} { yylval.str = strdup(yytext); return VAR_ASSIGN; }
{SHEBANG} { return SHEBANG; }
{COMMENT} { /* игнорируем комментарии */ }
<STRING>{QUOTE} { BEGIN(INITIAL); return QUOTE; }
<STRING>{STR_CONTENT} { yylval.str = strdup(yytext); return STRING_CONTENT; }
<STRING>\n { printf("STRING_UNTERMINATED\n"); BEGIN(INITIAL); return STRING_UNTERMINATED; }
\n { return NEWLINE; }
{WS} { /* ignore whitespace */ }
{IDENT} { yylval.str = strdup(yytext); return IDENT; }
{OTHER} { return OTHER; }
%%