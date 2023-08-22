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


%token<str> PRINT ABREP FECHAP VIRGULA ID STR NUM FIM_ENTRADA FIM_DE_LINHA ATRIB IF ELIF ELSE MAIOR MENOR IGUAL
%type<str> COMANDOS COMANDO VARIAVEIS VALOR CONDICAO

%%

COMANDOS : COMANDO
         | COMANDOS COMANDO
         ;

VARIAVEIS : VALOR
          | ID ATRIB VALOR
          | ID ATRIB VALOR VIRGULA VARIAVEIS
          ;

COMANDO : PRINT ABREP VARIAVEIS FECHAP FIM_DE_LINHA
    { 
        printf("console.log(%s);\n", $3);
    }
    | PRINT ABREP VARIAVEIS FECHAP
    { 
        printf("console.log(%s);\n", $3);
    }
    | ID ATRIB VALOR FIM_DE_LINHA
    {
        printf("let %s = %s;\n", $1, $3);
    } 
    | ID ATRIB CONDICAO FIM_DE_LINHA
    {
        printf("let %s;\nif (%s) {\n", $1, $3);
    }
    | IF ABREP CONDICAO FECHAP FIM_DE_LINHA
    {
        printf("if (%s) {\n", $3);
    }
    | ELIF ABREP CONDICAO FECHAP FIM_DE_LINHA
    {
        printf("} else if (%s) {\n", $3);
    }
    | ELSE FIM_DE_LINHA
    {
        printf("} else {\n");
    }
    ;

CONDICAO : ID MAIOR VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" > ") + 1);
    sprintf(temp, "%s > %s", $1, $3);
    $$ = temp;
}
| ID MENOR VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" < ") + 1);
    sprintf(temp, "%s < %s", $1, $3);
    $$ = temp;
}
| ID IGUAL VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" === ") + 1);
    sprintf(temp, "%s === %s", $1, $3);
    $$ = temp;
};

VALOR : ID { $$ = $1; }
      | STR { $$ = $1; }
      | NUM { $$ = $1; }
      ;

%%
void yyerror(const char *msg) {
    if (strcmp(msg, "syntax error") != 0 || yytext[0] != '\0') {
        fprintf(stderr, "Erro na linha %d: %s\n", yylineno, msg);
    }
    // Continue parsing after an error
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
