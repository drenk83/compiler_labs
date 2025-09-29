%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
extern YYSTYPE yylval;
%}
%option yylineno
NUMBER [0-9]+
ID [a-zA-Z_][a-zA-Z0-9_]*
STRING (\"[^"]*\"|'[^']*')
WS [ \t]+
DOLLAR "\$"
LBRACE "\{"
RBRACE "\}"
LPAREN "("
RPAREN ")"

%%
"#!/bin/bash"[ \t]*	{ return SHEBANG; }
#.* { }

"if" { return IF; }
"then" { return THEN; }
"elif" { return ELIF; }
"else" { return ELSE; }
"fi" { return FI; }
"time" { return TIME; }
"for" { return FOR; }
"in" { return IN; }
"until" { return UNTIL; }
"while" { return WHILE; }
"do" { return DO; }
"done" { return DONE; }
"case" { return CASE; }
"esac" { return ESAC; }
"coproc" { return COPROC; }
"select" { return SELECT; }
"function" { return FUNCTION; }
{ID} { return ID; }

= { return EQUAL; }
{DOLLAR} { return DOLLAR; }
\$\{[^{}}]*\}    { return DOLLAR_BRACED; }
{LBRACE} { return LBRACE; }
{RBRACE} { return RBRACE; }
{LPAREN} { return LPAREN; }
{RPAREN} { return RPAREN; }
"|" { return PIPE; }
"&" { return AMP; }
";" { return SEMI; }
"<" { return LT; }
">" { return GT; }
"!" { return BANG; }
"\[\[" { return LDBRACKET; }
"\]\]" { return RDBRACKET; }

{STRING} { return STRING; }
{NUMBER} { return NUMBER; }

{WS} { return WS; }
\n { return NEWLINE; }

. {
    fprintf(stderr, "Неожиданный символ: %s (строка %d)\n", yytext, yylineno);
}
%%
int yywrap() {
    return 1;
}