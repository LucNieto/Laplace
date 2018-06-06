laplace: main_2.c lex_2.yy.c parser_2.tab.c 
	gcc -g main_2.c lex_2.yy.c parser_2.tab.c -o laplace

lex_2.yy.c: parser_2.tab.c lex_2.l
	lex  -o lex_2.yy.c  lex_2.l

parser_2.tab.c: parser_2.y
	bison -d parser_2.y

clean: 
	rm -rf lex_2.yy.c parser_2.tab.c parser_2.tab.h laplace

