%{
#include "calculator.tab.h"
#include <stdio.h>
%}

%%
[0-9]+       {yylval = atoi(yytext); return NUMBER; }
[ \t\r]+     ;
\n           { return '\n';}
"+"          { return PLUS; }
"-"          { return MINUS; }
"*"          { return TIMES; }
"/"          { return DIVIDE; }
"("          { return LPAREN; }
")"          { return RPAREN; }
.            { printf("Invalid character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}