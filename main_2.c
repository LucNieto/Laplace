#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser_2.tab.h"
#define MAG   "\x1B[35m"
#define RESET "\x1B[0m"
//llamado a las funciones del parser, yylex regresa el numero de token y el valor que contiene
//yyline regresa el numero de la línea

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
	printf("Porfavor ingrese la Ec. Diferencial y agregue \";\" al final de la línea\n");
		yyin = stdin;

	 //while(!feof(yyin)){
	 //		yyparse();
	//// }	
	do { 
	printf(MAG"Laplace-UAA: "RESET);
	yyparse();
	} while(!feof(yyin));

	//printf("%s\n",value );
	return 0;
}

