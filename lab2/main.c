#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h" 

int main(int argc, char **argv) {
    int i;
    for (i = 0; i < MAX_VARS; i++) {
        vars[i].deg = -1;  
    }
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror(argv[1]);
            return 1;
        }
    } else {
        yyin = stdin;
    }
    yyparse();
    if (argc > 1) {
        fclose(yyin);
    }
    return 0;
}