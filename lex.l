%{
	#include "parser.tab.h"
	#include <string.h>
	extern char* yytext;
%}

espacio      [ \t\r\v\f]
salto_de_linea        \n

%%
[-+]?[0-9]+		{yylval.ival = atoi(yytext); return NUMERO;}

[a-z]                               {yylval.charVal = yytext[0];    return VARIABLE;}

"/*"((\*+[^/*])|([^*]))*\**"*/" 	{;}
"//".* {;}
"(" { return ABRE_PARENTESIS; }
")" { return CIERRA_PARENTESIS; }
"+"	{return MAS;}
"-"	{return MENOS;}
"*"	{return POR;}
"/"	{return ENTRE;}
"^"	{return AL;}
"'" {return PRIMA;}
";" {return PUNTO_Y_COMA;}

{salto_de_linea}                        {yylineno++;}
{espacio}                                    {;}
.				printf("%s es caracter desconocido\n",yytext);
%%



int yywrap(void){
	return 1;
}

