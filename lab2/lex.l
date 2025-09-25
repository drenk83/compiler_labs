%{
#include <stdio.h>
#include <stdlib.h>
#include "poly.h"
#include "y.tab.h"
%}
DIGIT [0-9]
NUMBER {DIGIT}+
%%
{NUMBER} { yylval.num = atoi(yytext); return NUMBER; }
[a-z] { yylval.var = yytext[0]; return VAR; }
\$[a-z]{1} { yylval.var = yytext[1]; return POLYVAR; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return TIMES; }
"^" { return POWER; }
"(" { return LPAREN; }
")" { return RPAREN; }
"=" { return ASSIGN; }
"print" { return PRINT; }
"//"[^\n\r]* { }
\n { yylineno++; return EOL; }
\r\n { yylineno++; return EOL; } /* Windows */
[ \t\r]+ { }
[A-Z]+ {
    fprintf(stderr, "[LEX] Line %d: Uppercase var not supported: '%s'\n", yylineno, yytext);
    return -1;
}
\$[A-Z]+ {
    fprintf(stderr, "[LEX] Line %d: Uppercase polyvar not allowed: '%s'\n", yylineno, yytext);
    return -1;
}
\$[a-z]+ {
    fprintf(stderr, "[LEX] Line %d: Multi-character polyvar not allowed: '%s'\n", yylineno, yytext);
    return -1;
}
{DIGIT}+\.{DIGIT}+ {
    fprintf(stderr, "[LEX] Line %d: Floating point numbers not supported: '%s'\n", yylineno, yytext);
    return -1;
}
. {
    fprintf(stderr, "[LEX] Line %d: Lexical error: Unexpected character '%s'\n",
            yylineno, yytext);
    return -1;
}
%%
int yywrap() { return 1; }