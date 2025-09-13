%{
#include <stdio.h>
#include <stdlib.h>
#include "poly.h"
#include "y.tab.h"
%}
DIGIT [0-9]
NUMBER {DIGIT}+(\.{DIGIT}+)?
%%
{NUMBER} { yylval.num = atof(yytext); return NUMBER; }
"x" { yylval.var = 'x'; return VAR; }
\$[a-z] { yylval.var = yytext[1]; return POLYVAR; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return TIMES; }
"^" { return POWER; }
"(" { return LPAREN; }
")" { return RPAREN; }
"=" { return ASSIGN; }
"print" { return PRINT; }
";" { return SEMI; }
"//"[^\n\r]* { return COMMENT; } /* Комментарий */
\n { yylineno++; return EOL; }
\r\n { yylineno++; return EOL; } /* Windows */
[ \t\r]+ { /* Пробелы */ }
. {
    fprintf(stderr, "Line %d: Lexical error: Unexpected character '%s'\n",
            yylineno, yytext);
    return -1;
}
%%
int yywrap() { return 1; }