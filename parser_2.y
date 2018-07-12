%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define SWITCH(S) char *_S = S; if (0)
#define CASE(S) } else if (strcmp(_S, S) == 0) {switch(1) { case 1
#define BREAK }
#define DEFAULT } else {switch(1) { case 1
#define RED   "\x1B[31m"
#define GRN   "\x1B[32m"
#define MAG   "\x1B[35m"
#define RESET "\x1B[0m"
	int yylex (void);
	void yyerror(char const *);
	extern char* yytext;
	extern int yylineno;
	int parser();
	long int multiplyNumbers(int n);
	char* superscript(long  x);
  char* symbols[10];
  char *symbolVal(char symbol);
	void updateSymbolVal(char symbol, char *val);
  char * laplaciano(char symbol);
  char *  laplaciano_int(int numero);
  void rec_log();
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
%type <charVal> signo 
%type <word> espacio_de_laplace
%type <word> funcion_igualdad 
%type <word> variable_independiente
%token  <charVal> ECUACION MAS MENOS  POR A_LA 
%token  <ival> NUMERO
%token  <word> Y_PRIMA Y_BIPRIMA Y  UN_MEDIO 
%token  VAR_INDEPENDIENTE EXIT_LAPLACE PRINT LAPLACE SENO SENO_H COSENO COSENO_H EULER 

%start input

%%
  input:  
       input line  ';'  {;//rec_log($1);
             //printf(MAG"Laplace-UAA : %s%s\n" RESET,GRN, $2); 
       } 
       |
       ;

  line: 

        EXIT_LAPLACE  {
           printf(MAG"Laplace-UAA: %s%s\n"RESET,GRN,"Adios");
      	   exit(EXIT_SUCCESS);
        }
        |  ECUACION '=' NUMERO {
           char * tmp;
           char l[sizeof ($3)+1];
           snprintf(l, sizeof (l)+1, "%d",$3);
           l[sizeof ($3)+1] = '\0';
           tmp = (char*) l;
           updateSymbolVal($1, tmp);
        }
        |  ECUACION '=' Y_PRIMA  {
            updateSymbolVal($1, $3);
        }
        |  ECUACION '=' Y_BIPRIMA  {
            updateSymbolVal($1, $3);
        }
        |  ECUACION '=' Y  {
            updateSymbolVal($1, $3);
        }        
        |  PRINT ECUACION {
            printf(GRN"%s\n" RESET, symbols[$2]);
        }
       
        |  LAPLACE '(' espacio_de_laplace ')'{
            printf(MAG"Laplace-UAA: %s%s\n" RESET,GRN, $3);
        }

        ;


  espacio_de_laplace:
        NUMERO {
          char * tmp = laplaciano_int($1);    
          $$ = tmp; 
        }
        | ECUACION  {
          char *tmp = symbols[$1];
          char l[sizeof (tmp)+1];
          snprintf(l, sizeof (l)+1, "%s",tmp);
          l[sizeof (tmp)+1] = '\0';
          if(isalpha(l[0])!=0){
              tmp = laplaciano($1); $$ = tmp;
            }else{
              tmp = laplaciano_int(atoi(tmp)); $$ = tmp;
            }
        }
        | variable_independiente{
          $$ =$1;
        }
        | funcion_igualdad {
            //printf(GRN"%s\n" RESET, $1);
            $$ = $1;
        }
        | NUMERO ECUACION  {
            //char * tmp = ("%d/s"); $$=tmp;// laplaciano($1); $$ = tmp;
             printf(" %d[%c]\n", $1, $2);
        }
        | ECUACION '=' funcion_igualdad {
            printf(GRN"%c = %s\n" RESET, $1,$3);
        }
        | NUMERO ECUACION '=' funcion_igualdad {
            printf(GRN"%d[%c] = %s\n" RESET, $1,$2,$4);
        }
        | ECUACION signo ECUACION '=' funcion_igualdad {
          // printf(GRN"%s %s %s = %s\n" RESET, $1,$2,$3,$5);
        }
        ;

  variable_independiente:

          VAR_INDEPENDIENTE {
          char* pot = superscript((2));
          char y[sizeof (pot)+4];
          snprintf(y, sizeof (y)+1, "[1/S^%s]",  pot);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }
        | 
          VAR_INDEPENDIENTE POR '(' EULER A_LA signo VAR_INDEPENDIENTE ')'  {
          char* pot = superscript((2));
          int num =1;
          char x[5];
          snprintf(x, sizeof(x), "- %d", num);
          if($6 == '-'){
          snprintf(x, sizeof(x), "+ %d", num);
          }
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[1/(s %s)^%s]",x,pot);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }
        |
          VAR_INDEPENDIENTE A_LA NUMERO POR '(' EULER A_LA signo VAR_INDEPENDIENTE ')'  {
          long facto = multiplyNumbers($3);
          char* pot = superscript(($3+1));
          int num =1;
          char x[5];
          snprintf(x, sizeof(x), "- %d", num);
          if($8 == '-'){
          snprintf(x, sizeof(x), "+ %d", num);
          }
          char y[sizeof (5)+24];
          snprintf(y, sizeof (y)+1, "[%ld/(s %s)^%s]",facto,x,pot);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }
        |
          VAR_INDEPENDIENTE POR '(' EULER A_LA signo NUMERO VAR_INDEPENDIENTE ')'  {
          char* pot = superscript((2));
          int num =$7;
          char x[5];
          snprintf(x, sizeof(x), "- %d", num);
          if($6 == '-'){
          snprintf(x, sizeof(x), "+ %d", num);
          }
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[1/(s %s)^%s]",x,pot);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }
        |
          VAR_INDEPENDIENTE A_LA NUMERO POR '(' EULER A_LA signo NUMERO VAR_INDEPENDIENTE ')'  {
          long facto = multiplyNumbers($3);
          char* pot = superscript(($3+1));
          int num =$9;
          char x[5];
          snprintf(x, sizeof(x), "- %d", num);
          if($8 == '-'){
          snprintf(x, sizeof(x), "+ %d", num);
          }
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[1/(s %s)^%s]",x,pot);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }
        |
          VAR_INDEPENDIENTE A_LA NUMERO  {
          int potencia = $3;
          long num = multiplyNumbers(potencia);
          char* pot = superscript((potencia+1));
          char y[sizeof (num)+20];
          snprintf(y, sizeof (y)+1, "[%ld/S^%s]",  num,  pot);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp; 
        } 
       | VAR_INDEPENDIENTE A_LA signo UN_MEDIO{
          if($3=='-'){
             char src[10], dest[10];
             strcpy(dest,  "\u221A(");
             strcpy(src, "\u03C0/s)");
             strcat(dest, src);
             char * tmp = dest;     $$ = tmp;
           }else{
             char src[10], dest[10];
             strcpy(dest,  "(\u221A\u03C0)/");
             strcpy(src, "(2s^\u00B3/\u00B2)");
             strcat(dest, src);
             char * tmp = dest;
             $$ = tmp;
         }
        }
        ;



  funcion_igualdad:
          signo EULER A_LA signo VAR_INDEPENDIENTE {
          char* pot = superscript((2));
          char* x = "- 1";
          if($4 == '-'){x="+ 1";}
          char y[sizeof (5)+10];
          snprintf(y, sizeof (y)+1, "[%c1/(s %s)]",$1,x);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }  

        | signo EULER A_LA signo VAR_INDEPENDIENTE POR '(' COSENO '(' VAR_INDEPENDIENTE')' ')'  { 
          char* pot = superscript((2));
          int k=1;
          int a=1;
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[s - %d/(s - %d)^%s + %d]",a,a,pot,(k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;

        } 
        | signo EULER A_LA signo NUMERO VAR_INDEPENDIENTE POR '(' COSENO '(' VAR_INDEPENDIENTE')' ')'  {
          
          char* pot = superscript((2));
          int k=1;
          int a=$5;
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[s - %d/(s - %d)^%s + %d]",a,a,pot,(k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;

        }
        |  signo EULER A_LA signo  VAR_INDEPENDIENTE POR '(' COSENO '(' signo NUMERO VAR_INDEPENDIENTE')' ')'  {
          
          char* pot = superscript((2));
          int k=$11;
          int a=1;
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[s - %d/(s - %d)^%s + %d]",a,a,pot,(k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;

        }  
       |  signo EULER A_LA signo  NUMERO VAR_INDEPENDIENTE POR '('COSENO '(' NUMERO VAR_INDEPENDIENTE')' ')'  {
          
          char* pot = superscript((2));
          int k=$11;
          int a=$5;
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[[s - %d/(s - %d)^%s + %d]",a,a,pot,(k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;

        } 
        |
          signo EULER A_LA signo VAR_INDEPENDIENTE POR '(' SENO '(' VAR_INDEPENDIENTE')' ')'  {
          
          char* pot = superscript((2));
          int k=1;
          int a=1;
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[%d/(s - %d)^%s + %d]",k,a,pot,(k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }  
         | signo EULER A_LA signo NUMERO VAR_INDEPENDIENTE POR '(' SENO '(' VAR_INDEPENDIENTE')' ')'  { 
          char* pot = superscript((2));
          int k=1;
          int a=$5;
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[%d/(s - %d)^%s + %d]",k,a,pot,(k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }
        |  signo EULER A_LA signo  VAR_INDEPENDIENTE POR '(' SENO '(' NUMERO VAR_INDEPENDIENTE')' ')'  {   
          char* pot = superscript((2));
          int k=$10;
          int a=1;
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[%d/(s - %d)^%s + %d]",k,a,pot,(k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }  
       |  signo EULER A_LA signo  NUMERO VAR_INDEPENDIENTE POR '(' SENO '(' NUMERO VAR_INDEPENDIENTE')' ')'  {
          char* pot = superscript((2));
          int k=$11;
          int a=$5;
          char y[sizeof (5)+17];
          snprintf(y, sizeof (y)+1, "[%d/(s - %d)^%s + %d]",k,a,pot,(k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }      
        | signo EULER A_LA signo NUMERO VAR_INDEPENDIENTE {
          char* pot = superscript((2));
          int k=$5;
          char sig='-';
          if($4 == '-'){sig='+';}
          char y[sizeof (5)+10];
          snprintf(y, sizeof (y)+1, "[%c1/(s %c %d)]",$1,sig,k);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        } 
       
        | SENO A_LA NUMERO '(' signo VAR_INDEPENDIENTE ')' {
          //N!/[s()]
          if($3==2){
            int k=1;
            int numerador = 2*(k*k);
            char* pot = superscript((2));
            int denominador=4*(k*k);
            char y[sizeof (pot)+10];
            snprintf(y, sizeof (y)+1, "%d/[s(s^%s + %d)]",numerador, pot,denominador);
            y[sizeof (y)+1] = '\0';
            char * tmp = (char*)y; $$ = tmp;
          }
        }   
       | SENO A_LA NUMERO '(' signo NUMERO VAR_INDEPENDIENTE ')' {
          //N!/[s()]
          if($3==2){
            int k=$6;
            int numerador = 2*(k*k);
            char* pot = superscript((2));
            int denominador=4*(k*k);
            char y[sizeof (pot)+10];
            snprintf(y, sizeof (y)+1, "%d/[s(s^%s + %d)]",numerador, pot,denominador);
            y[sizeof (y)+1] = '\0';
            char * tmp = (char*)y; $$ = tmp;
          }
        }  
        | SENO '(' signo VAR_INDEPENDIENTE ')' {
          char* pot = superscript((2));
          char y[sizeof (pot)+8];
          snprintf(y, sizeof (y)+1, "[%c1/(s^%s + 1)]",$3, pot);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }  
        | SENO '(' signo NUMERO VAR_INDEPENDIENTE ')' {
          int k = $4;
          char* pot = superscript((2));
          char y[sizeof (pot)+8];
          snprintf(y, sizeof (y)+1, "[%c%d/(s^%s + %d)]",$3, k, pot, (k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        } 
        | COSENO '(' VAR_INDEPENDIENTE ')' {
         char src[10], dest[10];
         strcpy(dest,  "s/(");
         strcpy(src, "s^\u00B2 +1)");
         strcat(dest, src);
         char * tmp = dest;
         $$ = tmp;
        }  
        | COSENO A_LA NUMERO '(' VAR_INDEPENDIENTE ')' {
          if($3==2){
            int k=1;
            int numerador = 2*(k*k);
            char* pot = superscript((2));
            int denominador=4*(k*k);
            char y[sizeof (pot)+18];
            snprintf(y, sizeof (y)+1, "(s^%s + %d)/[s(s^%s + %d)]",pot,numerador, pot,denominador);
            y[sizeof (y)+1] = '\0';
            char * tmp = (char*)y; $$ = tmp;
          }
        }  
        | COSENO A_LA NUMERO '(' signo NUMERO VAR_INDEPENDIENTE ')' {
          if($3==2){
            int k=$6;
            int numerador = 2*(k*k);
            char* pot = superscript((2));
            int denominador=4*(k*k);
            char y[sizeof (pot)+18];
            snprintf(y, sizeof (y)+1, "(s^%s + %d)/[s(s^%s + %d)]",pot,numerador, pot,denominador);
            y[sizeof (y)+1] = '\0';
            char * tmp = (char*)y; $$ = tmp;
          }
        } 
        | COSENO '(' signo NUMERO VAR_INDEPENDIENTE ')' {
          int k = $4;
          char* pot = superscript((2));
          char y[sizeof (pot)+12];
          snprintf(y, sizeof (y)+1, "[s/(s^%s + %d)]", pot, (k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        } 
        | SENO_H '(' signo VAR_INDEPENDIENTE ')' {
          char* pot = superscript((2));
          char y[sizeof (pot)+8];
          snprintf(y, sizeof (y)+1, "[%c1/(s^%s - 1)]",$3, pot);
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        }
        | SENO_H A_LA NUMERO '(' signo VAR_INDEPENDIENTE ')' {
          if($3==2){
            int k=1;
            int numerador = 2*(k*k);
            int denominador= 4*(k*k);
            char* pot = superscript((2));
            char y[sizeof (pot)+17];
            snprintf(y, sizeof (y)+1, "[%d/s(s^%s - %d)]",numerador, pot,denominador);
            y[sizeof (y)+1] = '\0';
            char * tmp = (char*)y; $$ = tmp;
          } 
        }     
        | SENO_H A_LA NUMERO '(' signo NUMERO VAR_INDEPENDIENTE ')' {
          if($3==2){
            int k=$6;
            int numerador = 2*(k*k);
            int denominador= 4*(k*k);
            char* pot = superscript((2));
            char y[sizeof (pot)+17];
            snprintf(y, sizeof (y)+1, "[%d/s(s^%s - %d)]",numerador, pot,denominador);
            y[sizeof (y)+1] = '\0';
            char * tmp = (char*)y; $$ = tmp;
          } 
        }  
        | SENO_H '(' signo NUMERO VAR_INDEPENDIENTE ')' {
          int k = $4;
          char* pot = superscript((2));
          char y[sizeof (pot)+8];
          snprintf(y, sizeof (y)+1, "[%c%d/(s^%s - %d)]",$3, k, pot, (k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        } 
        | COSENO_H '(' VAR_INDEPENDIENTE ')' {
         char src[10], dest[10];
         strcpy(dest,  "s/(");
         strcpy(src, "s^\u00B2 - 1)");
         strcat(dest, src);
         char * tmp = dest;
         $$ = tmp;
        } 
        | COSENO_H A_LA NUMERO '(' VAR_INDEPENDIENTE ')' {
           if($3==2){ 
              int k=1;
              int numerador = 2*(k*k);
              int denominador = 4*(k*k);
              char* pot = superscript((2));
              char y[sizeof (pot)+17];
              snprintf(y, sizeof (y)+1, "(s^%s - %d)/s(s^%s - %d)", pot,numerador,pot, denominador);
              y[sizeof (y)+1] = '\0';
              char * tmp = (char*)y; $$ = tmp;
           }
        } 
        | COSENO_H A_LA NUMERO '(' signo NUMERO VAR_INDEPENDIENTE ')' {
           if($3==2){ 
              int k=$6;
              int numerador = 2*(k*k);
              int denominador = 4*(k*k);
              char* pot = superscript((2));
              char y[sizeof (pot)+17];
              snprintf(y, sizeof (y)+1, "(s^%s - %d)/s(s^%s - %d)", pot,numerador,pot, denominador);
              y[sizeof (y)+1] = '\0';
              char * tmp = (char*)y; $$ = tmp;
           }
        } 
        | COSENO_H '(' signo NUMERO VAR_INDEPENDIENTE ')' {
          int k = $4;
          char* pot = superscript((2));
          char y[sizeof (pot)+8];
          snprintf(y, sizeof (y)+1, "[s/(s^%s - %d)]", pot, (k*k));
          y[sizeof (y)+1] = '\0';
          char * tmp = (char*)y; $$ = tmp;
        } 
        ;


  signo:  MAS { $$ = $1; 
        }
        | MENOS { $$ = $1;
        }
        | {$$ = ' ';}
        ;



%%
  char *  laplaciano_int(int num){
          char * tmp;
          char l[sizeof (num)+1];
          snprintf(l, sizeof (l)+1, "%d/s",num);
          l[sizeof (num)+1] = '\0';
          tmp = (char*) l;
          return tmp;
  }

  char * laplaciano(char symbol){
         char * tmp = symbols[symbol];
         SWITCH(tmp) {
            CASE ("y"):   tmp = "Y";
              BREAK;
            CASE ("y'"):   tmp = "SY(s)";
              BREAK;
            CASE ("y''"):  tmp = "S^\u00B2Y(s)";
              BREAK;
            CASE ("t"): tmp = "1/S^\u00B2"; 
              BREAK;
            DEFAULT:
              printf("Laplaciano no definido\n"); 
              BREAK;
          }
          return tmp;
  }

  void yyerror(char const *x){
  	printf(RED"Error en la línea %d, detalles: %s \n"RESET, yylineno, x);
   }

  char* superscript(long  num){
        long x = num;
        char y[sizeof (x)+1];
        snprintf(y, sizeof (y)+1, "%ld",x);
        y[sizeof (x)] = '\0';
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

  void updateSymbolVal(char symbol, char *val){
      int num_chars;
      num_chars = strlen(val) + 1;
      symbols[symbol] = (char*) malloc(num_chars);
      strcpy(symbols[symbol], val);
  }

long int multiplyNumbers(int n){
    if (n >= 1)
        return n*multiplyNumbers(n-1);
    else
        return 1;
}


char* itoa(int number){
  static char buffer[33];
  snprintf(buffer, sizeof(buffer), "%d", number);
  return buffer;
}



/*
  This function converts FLOATING POINT NUMBER to ASCII
  The equivalent ascii value of "number" is stored in the character array "buffer" and is returned .
  snprintf() accomplishes this task
*/
char* ftoa(float number){
   static char buffer[33];
  snprintf(buffer, sizeof(buffer), "%f", number);
  return buffer;
}


/*
  This function converts CHARACTER to ASCII
  The equivalent ascii value of "number" is stored in the character array "buffer" and is returned .
  snprintf() accomplishes this task
*/
char* ctoa(char number){
  static char buffer[33];
  snprintf(buffer, sizeof(buffer), "%c", number);
  return buffer;
}

/*void rec_log(char *line ){
//char *line = NULL;
//ssize_t bufsize = 0; // have getline allocate a buffer for us
//getline(&line, &bufsize, stdin);
FILE *fptr;
fptr = fopen("aaaaaa.md", "w");
fprintf(fptr, "%s",line);
fclose(fptr);
}*/

/*
char str[80];
strcpy(str, "these ");
strcat(str, "strings ");
strcat(str, "are ");
strcat(str, "concatenated.");
*/