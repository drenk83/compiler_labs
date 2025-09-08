%{
#include "y.tab.h"
%}

%%

[0-9]+ { yylval = atoi(yytext); return NUMBER; }
[ \t] ; /* ignore whitespace */
\n     { return '\n'; }  /* Возвращаем '\n' как токен для грамматики */
.      { return yytext[0]; } /* operators */

%%

int yywrap() { return 1; }