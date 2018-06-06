%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define RED   "\x1B[31m"
#define GRN   "\x1B[32m"
#define YEL   "\x1B[33m"
#define BLU   "\x1B[34m"
#define MAG   "\x1B[35m"
#define CYN   "\x1B[36m"
#define WHT   "\x1B[37m"
#define RESET "\x1B[0m"
	int yylex (void);
	void yyerror(char const *);
	char* strval;
	int num;
	extern char* yytext;
	extern int yylineno;
	int parser();
	long int multiplyNumbers(int n);
	char* superscript(long  x);
    char ecu[20];
    char* symbols[10];
    char *symbolVal(char symbol);
	void updateSymbolVal(char symbol, char *val);
	int computeSymbolIndex(char token);

%}

%define parse.lac full
%define parse.error verbose

%union {
  char* word;
  int ival;
  float fval;
  char charVal;
}
%type <word> line
%token  <charVal> ECUACION
%token  <word> PRIMA BIPRIMA 
%token  NUMERO VAR_INDEPENDIENTE EXIT_LAPLACE PRINT

%start input

%%
input:  input line  ';'  {
 printf(MAG"Laplace-UAA : %s%s\n" RESET,GRN, $2); 
 } 
|
  ;

    line: EXIT_LAPLACE  {
	    	  printf("Adios\n");
	    	  exit(EXIT_SUCCESS);
          	}
        | BIPRIMA {
          		$$ = $1; //printf("ecuacion %s ", $1);
        	}
        | PRIMA {
        	$$ = $1; //printf("ecuacion %s ", $1);
        }
        |  ECUACION '=' PRIMA  {
       // updateSymbolVal($1,$3);
        $$ = $3;
      // strcpy(ecu, $3); 
      //printf("%d",$1);
      //strcat(symbols[$1],$3 );
      int num_chars;
      num_chars = strlen($3) + 1;
      symbols[$1] = (char*) malloc(num_chars);
      strcpy(symbols[$1], $3);
     // symbols[$1] =$3;

       }
        | PRINT ECUACION {
        //printf(MAG"Laplace-UAA : %s%s\n" RESET,GRN, ecu);
         //printf("%d\n",$2);
        //printf(" %s\n",symbols[$2]);
         $$ = symbols[$2];
        }
    ;
%%
  void yyerror(char const *x){
	printf("Error %s in line %d\n", x, yylineno);
	//exit(1);
   }

   void updateSymbolVal(char symbol, char *val){
		int bucket = computeSymbolIndex(symbol);
		//symbols[bucket] = val;
		strcpy(symbols[bucket], val);
	}

	int computeSymbolIndex(char token){
		int idx = -1;
		if(islower(token)) {
			idx = token - 'a' + 26;
		} else if(isupper(token)) {
			idx = token - 'A';
		}
		return idx;
	} 
	char *symbolVal(char symbol){
		int bucket = computeSymbolIndex(symbol);
		return symbols[bucket];
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

/*
char str[80];
strcpy(str, "these ");
strcat(str, "strings ");
strcat(str, "are ");
strcat(str, "concatenated.");
*/