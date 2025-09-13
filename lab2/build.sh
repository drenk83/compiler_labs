#!/bin/bash
rm -f lex.yy.c y.tab.* y.output poly
echo "removed old files"
flex lex.l
echo "lex complete"
bison -d -y poly.y
echo "yacc complete"
#gcc lex.yy.c y.tab.c main.c -o poly -lfl
gcc lex.yy.c y.tab.c -o poly -lfl -lm 
echo "gcc complete!"