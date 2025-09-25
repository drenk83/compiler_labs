flex lex_bash.l         # Генерирует lex.yy.c
echo "lex"
bison -d -y pars_bash.y    # Генерирует y.tab.c и y.tab.h
echo "bison"
gcc -o bash_parser y.tab.c lex.yy.c -lfl  # -lfl для Flex библиотеки