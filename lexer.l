%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "arquivo.tab.h"
%}

%option noyywrap
%option nodefault
%option yylineno

BRANCO [ \t]
ESPACO {BRANCO}+

DIGITO [0-9]
NUMERO {DIGITO}+

LETRA [A-Za-z]
STRING_SIMPLES \'[^']*\'
STRING \"[^"]*\"
IDENTIFICADOR {LETRA}+

%%

","          { return VIRGULA; }
"print"      { return PRINT; }
"("          { return ABREP; }
")"          { return FECHAP; }
"="          { return ATRIB; }
{IDENTIFICADOR} { yylval.str = strdup(yytext); return ID;}
{STRING} { yylval.str = strdup(yytext); return STR;}
{STRING_SIMPLES} { yylval.str = strdup(yytext); return STR;}
{NUMERO} { yylval.str = strdup(yytext); return NUM; }
<<EOF>> { return FIM_ENTRADA; } // Return FIM_ENTRADA token at end of input
{ESPACO}    { /* Ignore whitespace */ }
.           { yyerror("Token desconhecido."); }
"\n"        { yylineno++; return FIM_DE_LINHA; }
%%
