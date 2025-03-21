%{

#include <stdio.h>
#include <stdlib.h>
#include "calculator.tab.h"
%}



%%
[0-9]+"."[0-9]+     { yylval.dval = atof(yytext); return FLOAT; }
[0-9]+              { yylval.ival = atoi(yytext); return INTEGER; }
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return TIMES; }
"/"                 { return DIVIDE; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"^"                 { return EXPONENT; }
\n                  { return '\n'; }
[ \t\r]+            ;
.                   { printf("Invalid character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}