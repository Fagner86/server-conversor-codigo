%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lex.yy.c"

extern FILE* yyin;

void yyerror(const char *msg) {
    if (yyparse() != 0) {
        printf("Erro de análise: %s\n", msg);
    }
    exit(0);
}
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
        char *variaveis = $3;
        printf("console.log(");
        imprimirVariaveis(variaveis);
        printf(");\n");
        free(variaveis);
    }
    | PRINT ABREP VARIAVEIS FECHAP
    { 
        char *variaveis = $3;
        printf("console.log(");
        imprimirVariaveis(variaveis);
        printf(");\n");
        free(variaveis);
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
void imprimirVariaveis(char *variaveis) {
    char *token = strtok(variaveis, ",");
    while (token != NULL) {
        if (strlen(token) >= 2 && token[0] == '\"' && token[strlen(token) - 1] == '\"') {
            printf("\"%s\"", token);
        } else {
            printf("%s", token);
        }
        token = strtok(NULL, ",");
        if (token != NULL) {
            printf(", ");
        }
    }
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
        // Continue processando o arquivo
    }
    
    printf("PROGRAMA RECONHECIDO!!!\n");
    fclose(yyin);
    return 0;
}
