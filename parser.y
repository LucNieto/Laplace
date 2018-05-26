%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
	int yylex (void);
	void yyerror(char const *);
	char* strval;
	int num;
	extern char* yytext;
	extern int yylineno;
	int parser();
	long int multiplyNumbers(int n);
	char* superscript(long  x);
void ensangrador();
void genera_lenguaje_maquina();
%}

%define parse.lac full
%define parse.error verbose

%union {
  char* strVal;
  int ival;
  float fval;
  char charVal;
}

%token <charVal> VARIABLE
%token <ival> NUMERO
%token <fval> DOBLE

//%type <strVal> EXPRESSION


%token   PRIMA MAS MENOS POR ENTRE IGUAL AL PUNTO_Y_COMA ABRE_PARENTESIS  CIERRA_PARENTESIS

%start input

%%
input:
  | line
  ;

  //line:  EXPRESSION 
  //;
 // DECLARATION: EXPRESSION MAS EXPRESSION MAS EXPRESSION IGUAL EXPRESSION PUNTO_Y_COMA {printf(" y''(t) + y'(t) + y(t) = f(t)");}
  //| EXPRESSION MAS EXPRESSION IGUAL EXPRESSION PUNTO_Y_COMA 
  //{printf("y'(t) + y(t) = f(t)");}
  //| EXPRESSION MENOS EXPRESSION MAS EXPRESSION IGUAL EXPRESSION PUNTO_Y_COMA
  //{printf(" y''(t) - y'(t) + y(t) = f(t)");}
 // | EXPRESSION MENOS EXPRESSION MENOS EXPRESSION IGUAL EXPRESSION PUNTO_Y_COMA
 // {printf(" y''(t) - y'(t) - y(t) = f(t)");}
  //| EXPRESSION MAS EXPRESSION MENOS EXPRESSION IGUAL EXPRESSION PUNTO_Y_COMA
  //{printf(" y''(t) + y'(t) - y(t) = f(t)");}
  //;

  line: NUMERO VARIABLE PRIMA ABRE_PARENTESIS VARIABLE CIERRA_PARENTESIS PUNTO_Y_COMA{
   char lap =toupper($2);

	printf("Espacio de Laplace %d[S%c(s)] \n",$1, lap);
  }
  |NUMERO PUNTO_Y_COMA{
  	printf("Espacio de Laplace: =  %d / s\n",$1);
  }
  | VARIABLE PRIMA ABRE_PARENTESIS VARIABLE CIERRA_PARENTESIS  PUNTO_Y_COMA{
   char lap =toupper($1);

	printf("Espacio de Laplace: S%c(s)\n", lap);
  }
  | VARIABLE ABRE_PARENTESIS VARIABLE CIERRA_PARENTESIS  PUNTO_Y_COMA {
     char lap =toupper($1);

	 printf("Espacio de Laplace: %c(s)\n", lap);
  }
  | NUMERO VARIABLE PRIMA PRIMA ABRE_PARENTESIS VARIABLE CIERRA_PARENTESIS PUNTO_Y_COMA {
     char lap =toupper($2);

	 printf("Espacio de Laplace %d[S^\u00B2%c(s)] \n",$1, lap);
  }
    | VARIABLE PRIMA PRIMA ABRE_PARENTESIS VARIABLE CIERRA_PARENTESIS PUNTO_Y_COMA {
     char lap =toupper($1);

	 printf("Espacio de Laplace S^\u00B2%c(s) \n", lap);
  }
   | VARIABLE PUNTO_Y_COMA {
	printf("Espacio de Laplace 1/S^\u00B2\n");
  }
  | VARIABLE AL NUMERO PUNTO_Y_COMA {
  int potencia = $3;
  long num = multiplyNumbers(potencia);
    char* pot_den = superscript(num+1);

  printf("Espacio de Laplace:  [%ld/S^%s]%c^%d",  multiplyNumbers(potencia),  pot_den,$1,$3);
  }
  ;



%%
long int multiplyNumbers(int n)
{
    if (n >= 1)
        return n*multiplyNumbers(n-1);
    else
        return 1;
}

void yyerror(char const *x){
	printf("Error %s in line %d\n", x, yylineno);
	exit(1);
}

void ensangrador(){
	char command[50];
	strcpy( command, "\ngcc -o ensamblador.s -S emp.c " );
   	system(command);
}

void genera_lenguaje_maquina(){
	char command[50];
	strcpy( command, "\ngcc -o ejecutable ensamblador.s " );
   	system(command);  	
}
char* superscript(long  num){
long x = num;
//printf("%ld\n", sizeof (x)+1);
char y[sizeof (x)+1];
snprintf(y, sizeof (y)+1, "%ld",x);
y[sizeof (x)+1] = '\0';
char utf[12]={};
for (int i = 0; i <=sizeof (x); i++){

 switch(y[i]) {

    case '0':  strcat(utf,"\u00B0");
      break;
    case '1':  strcat(utf,"\u00B9");
      break;
    case '2':  strcat(utf,"\u00B2");
      break;
    case '3':  strcat(utf,"\u00B3");
      break;
    case '4':  strcat(utf,"\u2074");
   	  break;
    case '5':  strcat(utf,"\u2075");
      break;
    case '6':  strcat(utf,"\u2076");
      break;
    case '7':  strcat(utf,"\u2077");
      break;
    case '8':  strcat(utf,"\u2078");
      break;
    case '9':  strcat(utf,"\u2079");
    	break;
    default:
        //printf("This is not a number\n"); 
        break;
  }
}
char* tmp = (char*)utf;
return tmp;
}