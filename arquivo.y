%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "arquivo.tab.h"
#include "lex.yy.c"
%}

%union {
    char *str;
}

%token<str> PRINT ABREP FECHAP VIRGULA ID STR NUM FIM_ENTRADA FIM_DE_LINHA
%type<str> COMANDOS COMANDO VARIAVEIS VALOR

%%

COMANDOS : COMANDO
         | COMANDOS COMANDO
         ;

COMANDO : PRINT ABREP VARIAVEIS FECHAP FIM_DE_LINHA
    { 
        printf("console.log(%s);\n", $3);
    }
    | PRINT ABREP VARIAVEIS FECHAP
    { 
        printf("console.log(%s);\n", $3);
    }
    ;

VARIAVEIS : VALOR
          | VALOR VIRGULA VARIAVEIS
          ;

VALOR : ID { $$ = $1; }
      | STR { $$ = $1; }
      | NUM { $$ = $1; }
      ;


%%
void yyerror(const char *msg) {
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Modo de uso: ./parser arquivo.print\n");
        return -1;
    }
    
    FILE* file = fopen(argv[1], "r");
    if (!file) {
        printf("Arquivo %s não encontrado!\n", argv[1]);
        return -1;
    }
    
    yyin = file;
    while (yyparse() == 0) {
        // Continue processing the file
    }
    
    printf("PROGRAMA RECONHECIDO!!!\n");
    fclose(yyin);
    return 0;
}
