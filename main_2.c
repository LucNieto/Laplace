#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser_2.tab.h"
#define MAG   "\x1B[35m"
#define RESET "\x1B[0m"


extern int yylineno;
extern char* yytext;
extern int yylex();
extern int yyparse();
extern FILE* yyin;

int main(int argc, char *argv[]){
	char command[22];
	strcpy( command, "\ncat introduccion.luc" );
   	system(command);
	printf("\n");
	yyin = stdin;	
	printf(MAG"Laplace-UAA: "RESET);
	do { 
		yyparse();
	} while(!feof(yyin));
	return 0;
}

