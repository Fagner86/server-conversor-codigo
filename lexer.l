%{
#include "arquivo.tab.h"
extern YYSTYPE yylval;
char* processString(char* input);
%}

%option noyywrap
%option nodefault
%option yylineno

BRANCO [ \t]
ESPACO {BRANCO}+

DIGITO [0-9]
NUMERO {DIGITO}+

LETRA [A-Za-z]
STRING \"[^"]*\"
IDENTIFICADOR {LETRA}+

%%
","          { return VIRGULA; }
"print"      { return PRINT; }
"("          { return ABREP; }
")"          { return FECHAP; }
{ESPACO}+
{NUMERO}     { yylval.str = strdup(yytext); return NUM; }
{STRING}     { yylval.str = processString(yytext); return STR; }
{DIGITO}+    { yylval.str = strdup(yytext); return NUM; }
{IDENTIFICADOR}  { yylval.str = strdup(yytext); return ID; }
\n           { return FIM_DE_LINHA; }
.            { return yytext[0]; } // Retornar o próprio caractere
%%

char* processString(char* input) {
    char* output = (char*)malloc(strlen(input) - 1);
    strncpy(output, input + 1, strlen(input) - 2);
    output[strlen(input) - 2] = '\0';
    return output;
}
