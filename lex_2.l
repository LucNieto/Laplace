N			      [+-]?[0-9]
P			      [a-zA-Z_]
C                 [a-rt-xz] 
espacio           [\t\r\v\f]
salto_de_linea    [ \n] 

%{
	#include "parser_2.tab.h"
	#include <string.h>
	extern char* yytext;
%}

%%
[-+]?[0-9]+		                 {yylval.ival = atoi(yytext); return NUMERO;}
"t"                              {yylval.charVal = yytext[0];    return VAR_INDEPENDIENTE;}
{C}                             { yylval.charVal  = yytext[0] - 'a';    return ECUACION;}
"y"("''")        { yylval.word = yytext; return BIPRIMA; }
"y"("'")        { yylval.word = yytext; return PRIMA; }
"salir"                       {return EXIT_LAPLACE; }
"imprimir"				   {return PRINT;}
"/*"((\*+[^/*])|([^*]))*\**"*/"  {;}
"//".*                           {;}
[-+()=*^;']                      {return *yytext;}
{salto_de_linea}                 {yylineno++;}
{espacio}                        {;}
.				                 {printf("%s es caracter desconocido o esta reservado\n¡Por favor revise su sintaxis!",yytext);}
%%

int yywrap(void){
	return 1;
}

