%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

DIGIT [0-9]
NUMBER {DIGIT}+(\.{DIGIT}+)?

%%

{NUMBER}        { yylval.num = atof(yytext); return NUMBER; }
[a-zA-Z]        { yylval.var = yytext[0]; return VAR; }
\$[a-zA-Z]      { yylval.var = yytext[1]; return POLYVAR; }

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"^"             { return POWER; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"="             { return ASSIGN; }
"print"         { return PRINT; }
";"             { return SEMI; }

"//".*          { /* Комментарий - игнорируем */ }
\n              { yylineno++; return EOL; }
[ \t\r]+        { /* Пробелы - игнорируем */ }

.               { 
                  fprintf(stderr, "Line %d: Lexical error: Unexpected character '%c' (ASCII %d)\n", 
                          yylineno, yytext[0], yytext[0]); 
                  return -1; 
                }

%%

int yywrap() { 
    return 1; 
}