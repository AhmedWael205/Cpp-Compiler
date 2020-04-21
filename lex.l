%{
    #include "yacc.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

%%

"const"                         return CONST;
"bool"                          return BOOL;
"int"                           return INT;
"char"                          return CHR;
"float"                         return FLT;
"true"                          return T;
"false"                         return F;
"="                             return EQUAL;
"+"                             return PLUS;                                 
"-"                             return MINUS;
"*"                             return MUL;
"/"                             return DIV;
"%"                             return REM;
"++"                            return INC;
"--"                            return DEC;
"&&"                            return AND;
"||"                            return OR;
"!"                             return NOT;
"=="                            return EQ;
"!="                            return NEQ;
">"                             return L;
"<"                             return G;
">="                            return LEQ;
"<="                            return GEQ;
"+="                            return PLUSEQ;
"-="                            return MINUSEQ;
"*="                            return MULEQ;
"/="                            return DIVEQ;
";"                             return SCOLON;
":"                             return COLON;
"{"                             return OCURLBRAC;
"}"                             return CCURLBRAC;
"("                             return OROUNDBRAC;
")"                             return CROUNDBRAC;


[a-zA-Z_][a-zA-Z_0-9]*          return IDENTIFIER;  
           		        
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

.                                yyerror("Unknown character");




%%

int yywrap(void) {
    return 1;
}
