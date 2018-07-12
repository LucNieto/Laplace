%{
	#include  "parser_2.tab.h"
	#include  <string.h>
	extern    char*  yytext;
	#define   RED    "\x1B[31m"
	#define   GRN    "\x1B[32m"
	#define   MAG    "\x1B[35m"
	#define   RESET  "\x1B[0m"
%}

N			                     [+-]?[0-9]
NF                               [-+]?[0-9]*\.?[0-9]+  
P			                     [a-zA-Z_]
C                                [a-rt-xz] 
espacio                          [\t\r\v\f]
salto_de_linea                   [ \n] 

%%
[0-9]+                           {yylval.ival = atoi(yytext); return NUMERO;}
"1/2"                            {yylval.word = yytext; return UN_MEDIO; }
"t"                              {yylval.charVal = yytext[0];    return VAR_INDEPENDIENTE;}
{C}                              {yylval.charVal  = yytext[0] - 'a';    return ECUACION;}
"y"("''")                        {yylval.word = yytext; return Y_BIPRIMA; }
"y"("'") 						 {yylval.word = yytext; return Y_PRIMA; }
"y"                              {yylval.word = yytext; return Y; }
"salir"[()]?                     {return EXIT_LAPLACE; }
"imprimir"				         {return PRINT;}
"laplace"				         {return LAPLACE;}
"cos"				         	 {return COSENO;}
"sen"				             {return SENO;}
"cosh"				         	 {return COSENO_H;}
"senh"				             {return SENO_H;}
"euler"				             {return EULER;}
"/*"((\*+[^/*])|([^*]))*\**"*/"  {;}
"//".*                           {;}
"+"	                             {yylval.charVal = yytext[0];    return MAS;}
"-"	                             {yylval.charVal = yytext[0];    return MENOS;}
"*"	                             {yylval.charVal = yytext[0];    return POR;}
"^"						         {yylval.charVal = yytext[0];    return A_LA;}
[()=;]                           {return *yytext;}//{yylval.charVal = yytext[0];    return yytext;}//{return *yytext;}
{salto_de_linea}                 {yylineno++; printf(MAG"Laplace-UAA: "RESET);}
{espacio}                        {;}
.				                 {printf(RED"%s es caracter desconocido o esta reservado\n¡Por favor revise su sintaxis!\n"RESET,yytext);}
%%

int yywrap(void){
	return 1;
}

