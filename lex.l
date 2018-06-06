D			[0-9]
L			[a-zA-Z_]

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
{L}({L}|{D})*     { yylval.var = *yytext - 'a'; return VAR; }
"/*"((\*+[^/*])|([^*]))*\**"*/" 	{;}
"//".* {;}
[-+()=*^;] { return *yytext; }
"'" {return PRIMA;}


{salto_de_linea}                        {yylineno++;}
{espacio}                                    {;}
.				printf("%s es caracter desconocido\n",yytext);
%%



int yywrap(void){
	return 1;
}

