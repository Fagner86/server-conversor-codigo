#include <stdio.h>
#include <stdlib.h>
#include "arquivo.tab.h"

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Modo de uso: %s arquivo.print\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Arquivo %s não encontrado!\n", argv[1]);
        return 1;
    }

    yyin = file;
    if (yyparse() == 0)
        printf("PROGRAMA RECONHECIDO!!!\n");

    fclose(yyin);
    return 0;
}
