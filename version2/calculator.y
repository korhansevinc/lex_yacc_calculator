%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void yyerror(const char *s);


#define ERROR_VAL -999999
%}

%union {
    int ival;   
    double dval;
}

%token <ival> INTEGER
%token <dval> FLOAT
%token PLUS MINUS TIMES DIVIDE EXPONENT LPAREN RPAREN


%type <dval> expr

%%

input:

    |   input expr '\n' { 
            if($2 != ERROR_VAL){
                if (floor($2) == $2) { 
                    printf("Result: %d\n", (int)$2); 
                } else {
                    printf("Result: %.6f\n", $2); 
                }
            }   
        }
    ;

expr:
        expr PLUS expr   { $$ = $1 + $3; }
    |   expr MINUS expr  { $$ = $1 - $3; }
    |   expr TIMES expr  { $$ = $1 * $3; }
    |   expr DIVIDE expr { 
            if ($3 == 0) {
                printf("Warning: Division by zero is undefined! Try again.\n");
                $$ = ERROR_VAL;
            } else if (floor($1) == $1 && floor($3) == $3) {
                $$ = (int)$1 / (int)$3;
            } else {
                $$ = $1 / $3;
            }
        }
    |   expr EXPONENT expr { $$ = pow($1, $3); }
    |   LPAREN expr RPAREN { $$ = $2; }
    |   INTEGER { $$ = $1; } 
    |   FLOAT   { $$ = $1; } 
    ;

%%

int programOpening = 1;

void yyerror(const char *s) {
    if(programOpening==1){
        programOpening = 0;
    }else{
        printf("Syntax Error: %s\n", s);
    }
}

typedef struct yy_buffer_state * YY_BUFFER_STATE;
extern int yyparse();
extern YY_BUFFER_STATE yy_scan_string(char * str);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

void run_test_cases() {
    char *test_cases[] = {
        "3 + 5\n",
        "3.3 + 5.47\n",
        "10 -  2\n",
        "10.3 - 2.1\n",
        "6  * 7\n",
        "6.2 * 7.3\n",
        "8 / 4\n",
        "8.4 / 2\n",
        "2 ^ 3\n",
        "(3 + 2) * 4\n",
        "10 / (2 + (7 - 4))\n",
        "(5 + 3 * 2)\n",
        "(5 + (3 * 2))\n",
        "7 / (1 + 6)\n",
        "193 / 0\n",
        "(2+ 3))\n", 
        "(3 + 5) * (2 - 1) / 3.2\n",
        "((2^5)^2)\n"
    };

    for(int i = 0; i<18; i++){
        printf("\nRunning test case %d: %s", i + 1, test_cases[i]);
        YY_BUFFER_STATE buffer = yy_scan_string(test_cases[i]);
        yyparse();
        yy_delete_buffer(buffer);        
    }
}

int main() {
    int decision;
    
    printf("Please select mode : ( 0-> Test Case Evaluation  |   1 -> Run time usage )\n");
    printf("To see the results of the test cases ENTER '0'.\n");
    printf("To use the calculator in terminal at the runtime ENTER '1'\n");
    scanf("%d",&decision);
    
    if(decision == 0){
        programOpening = 0;
        run_test_cases();
    printf("The test cases has been evaluated.\n");
    }
    else if(decision == 1){
        printf("Enter expressions or CTRL + C to exit:\n");
        YY_BUFFER_STATE buffer = NULL;
        yy_delete_buffer(buffer);
        while(yyparse());
    }else{
        printf("ERROR : There is no such decision other than 0 or 1.\n");
    }
    
    return 0;
}