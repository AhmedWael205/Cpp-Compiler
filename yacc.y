%{
    #include <stdio.h>
    //function decleration
    int yylex(void);
    void yyerror(char *);
        int sym[26];

   
     
    
%}

%union
{
    int iValue;              
    char cValue;                
    float fValue;
};

%token CONST BOOL INT IDENTIFIER FLT CHR 
%token T F EQUAL REM INC DEC AND OR NOT PLUSEQ MINUSEQ MULEQ DIVEQ
%token SCOLON COLON OCURLBRAC CCURLBRAC OROUNDBRAC CROUNDBRAC
%token <iValue> INTEGER
%token <fValue> FLOAT
%token <cValue> CHARACTER


%left L G EQ LEQ GEQ NEQ
%left PLUS MINUS MUL DIV
%nonassoc UMINUS

%%

program:
         program stmt 
         |           
        ;

stmt:
expr SCOLON      
|decleration 
;

decleration:
        data_type IDENTIFIER SCOLON            {printf("DECLERATION ONLY \n");} /*set its scope*/ /*decleration only*/
        |data_type IDENTIFIER EQUAL expr SCOLON  {  printf("DECLERATION WITH INTIALIZATION\n");}                 /*decleration and intialization*/
        |CONST data_type IDENTIFIER EQUAL expr SCOLON   { printf("CONST DECLERATION WITH INTIALIZATION\n");}        /*CONST decleration and intialization*/
        ;

data_type:
        INT
        |FLT
        |CHR
        |BOOL
        ;

expr:
    or_expr   { printf("or_expr\n"); } 
    |inc_dec   { printf("INC_DEC\n"); }  
    ;

inc_dec:       
        | IDENTIFIER INC   { printf("PRE_INC\n"); }                  
        | IDENTIFIER DEC   { printf("PRE_DEC\n"); }                  
        | INC IDENTIFIER  { printf("POST_INC\n"); }                  
        | DEC IDENTIFIER  { printf("POST_DEC\n"); }       
        ;

or_expr:
        or_expr OR and_expr { printf("OR\n"); }     
        |and_expr        { printf("and_expr\n"); }         
        ;

and_expr:
        and_expr AND eq_expr  { printf("AND\n"); } 
        |eq_expr           { printf("eq_expr\n"); }      
        ;
eq_expr:
        eq_expr EQ rel_expr    { printf("EQ \n"); } 
        |eq_expr NEQ rel_expr  { printf("NEQ\n"); } 
        |rel_expr          { printf("rel_expr \n"); }      
        ;

rel_expr:
        rel_expr G math_expr      { printf("G \n"); }
        | rel_expr L math_expr    { printf("L\n"); }
        | math_expr GEQ math_expr  { printf("GE\n"); }       
        | rel_expr LEQ math_expr  { printf("LE \n"); }      
        | math_expr             { printf("math_expr \n"); }
        | NOT math_expr   { printf("NOT \n"); }        
        |T              { printf("TRUE\n"); }          
        |F              { printf("FALSE\n"); }
        ;


math_expr:
        MINUS math_expr %prec UMINUS        
        | math_expr PLUS math_expr      { printf("PLUS \n"); }                    
        | math_expr MINUS math_expr      { printf("MINUS\n");  }        
        | math_expr MUL math_expr         { printf("MUL\n");  }    
        | math_expr DIV math_expr         { printf("DIV \n"); }   
        | OROUNDBRAC math_expr CROUNDBRAC { printf("BRACKET \n");  }  
        | math_expr_element              { printf("ELEMENT\n");  }
        ;

math_expr_element:
                 INTEGER        { printf("int\n");  }
                 |FLOAT         { printf("float\n");  }
                 |CHARACTER     { printf("char\n");  }
                 |IDENTIFIER     { printf("identifier\n");  }
                 ;


 


%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
