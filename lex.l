%{
    #include "y.tab.h"
    #include <stdlib.h>
    #include <string.h>
    void yyerror(char *);
%}

%%

"const"                         return CONST;
"int"                           return INT;
"char"                          return CHR;
"float"                         return FLT;
"="                             return EQUAL;
"+"                             return PLUS;                                 
"-"                             return MINUS;
";"                             return SCOLON;



[a-zA-Z_][a-zA-Z_0-9]*          {yylval.varName =strdup(yytext);return IDENTIFIER;} 
           		        
[0-9]+                          {  yylval.iValue = atoi(yytext);
                                   return INTEGER; 
                                }

[0-9]+[\.][0-9]+                {  yylval.fValue = atof(yytext);
                                   return FLOAT; 
                                } 

[\'][a-zA-z][\']                {
                                    yylval.cValue = yytext[1];
                                    return CHARACTER;
                                }

[ \t]                           ;   /*Skip WhiteSpace*/

.                                yyerror("Unknown character\n");




%%

int yywrap(void) {
    return 1;
}
