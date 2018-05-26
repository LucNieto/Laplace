# Davinci es un proyecto hecho en C con flex y bison para generar los arboles de derivación
# Para compilar el proyecto seguir los siguientes pasos
#
# 1  $flex lex.l
# 2  $bison -d parser.y
# 3  $gcc -o compilador main.c lex.yy.c parser.tab.c
# 4  $./compilador < codigo.luc
# 5  $./ejecutable


