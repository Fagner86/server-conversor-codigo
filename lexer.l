%option noyywrap
%option nodefault
%option yylineno

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Buffer para armazenar o resultado da conversão
char result[4096];

%}

%%
"count = 0"       { strcat(result, "let count = 0;\n"); }
"while count < 5:"   { strcat(result, "while (count < 5) {\n"); }
"    print(\"Contagem:\", count)"  { strcat(result, "    console.log(\"Contagem:\", count);\n"); }
"    count += 1"    { strcat(result, "    count += 1;\n"); }
.    { strcat(result, yytext); }
%%

// Esta função é chamada no código do servidor para analisar a entrada fornecida.
const char* parseInput(const char *input) {
    result[0] = '\0'; // Inicializa o buffer de resultado
    yy_scan_string(input);
    yylex();
    return result;
}