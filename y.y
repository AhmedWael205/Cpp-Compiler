%{
//      INCLUDES
    #include <stdio.h>
    #include <stdbool.h>
    #include "symbolTable.h"


//      PROTOTYPES
    int yylex(void);
    void yyerror(char *);
    bool declare(char *identifier, int type);
    bool existAndInitialized (char* variableName);
    bool validateAssign(int firstOperandType, int secondOperandType, bool mathOperation);
    bool assign(char* variableName, int lhsType, int rhsType);

//      VARIABLES
int currentDataType,currentType;
int lhsType, rhsType;
int firstOperandType;
int regCount;
int firstReg;
int secondReg;
bool declaring;
extern FILE *yyin;



FILE *assembly;
FILE *testFile;
FILE *errorFile;
     
    
%}

%union
{
    int iValue;              
    char cValue;                
    float fValue;
    char* varName;
};

%start program
%token CONST INT FLT CHR 
%token EQUAL
%token SCOLON
%token <iValue> INTEGER
%token <fValue> FLOAT
%token <cValue> CHARACTER
%token <varName> IDENTIFIER

%left PLUS MINUS

%%

program:
	sentence {printSymbolTable();}program
	|
        ;

sentence:
        assignment   
        |{declaring = true;} declaration {declaring = false;}
        ;

declaration:
        data_type IDENTIFIER SCOLON      {declare($2,currentDataType);}
        |data_type assignment  
        |CONST data_type {currentDataType += 3;} assignment 
        ;

assignment:
        IDENTIFIER EQUAL { regCount = 0;}
        expr { rhsType = currentType;}
        SCOLON { 
                if (rhsType != -9) {
                        if(declaring)
                                if (rhsType == currentDataType || rhsType == currentDataType + 3 || rhsType == currentDataType -3)
                                { 
                                        declare($1,currentDataType);
                                        lhsType = currentDataType;
                                }
                        else {lhsType = getType($1);}
                        if (assign($1, lhsType, rhsType)) {
                                fprintf(assembly,"\n MOV %s , R%d", $1 ,regCount);
                                setVariable($1);
                                }
                        else{yyerror("Error in assigning variable \n"); }

                } else {yyerror("Error in assigning variable \n");}
        }
        ;

data_type:
        INT {currentDataType = 0;}
        |FLT {currentDataType = 1;}
        |CHR {currentDataType = 2;}
        ; 



expr:        
        expr_element PLUS {firstOperandType = currentType; firstReg = regCount++;} expr_element { if(validateAssign(firstOperandType, currentType,true)) {
                                                                                                        secondReg = regCount++; 
                                                                                                        fprintf(assembly,"\n ADD R%d,R%d,R%d",regCount,firstReg,secondReg );}
                                                                                                        else {currentType = -9;}}                    
        | expr_element MINUS {firstOperandType = currentType; firstReg = regCount++;} expr_element { if(validateAssign(firstOperandType, currentType,true)) {
                                                                                                        secondReg = regCount++; 
                                                                                                        fprintf(assembly,"\n SUB R%d,R%d,R%d",regCount,firstReg,secondReg );}
                                                                                                        else {currentType = -9;}}     
        | expr_element
        ;

expr_element:
                 INTEGER        { currentType = 0; fprintf(assembly,"\n MOV R%d, %d",regCount, $1);}
                 |FLOAT         { currentType = 1; fprintf(assembly,"\n MOV R%d, %f", regCount,$1 );}
                 |CHARACTER     { currentType = 2; fprintf(assembly,"\n MOV R%d, '%c'",regCount,$1 );}
                 |IDENTIFIER    { if(existAndInitialized($1)) {
                  currentType = getType($1);fprintf(assembly,"\n MOV R%d, %s",regCount, $1);
                  } else {
                        currentType = -9;
                        }  
                  }
                 ;


 


%%

bool declare(char *identifier, int type) {

        if(addVariable(identifier, type)) return true;
        yyerror("Error variable is already declared\n");
        return false;

			
}

bool existAndInitialized (char* variableName)
{
        int x = existandInitialized(variableName);
        if (x == -1) 
        {
                yyerror("Error variable is not declared \n"); 
                return false; 
        } else if (x == 0)
        {
                yyerror("Error variable is not initialized\n");
                return false;
        }
        return true;
}

bool validateAssign(int x, int y,bool op)
{
        // x is firstOperandType
        // y is secondOperandType
        // op is mathOperation
        if(op)
                if (x == 2 || x == 5 || y == 2 || y == 5)
                {
                        yyerror("Error mathematical operation cant be applied on char type\n");
                        return false;
                }
        if (x == -9 || y == -9) return false;
	if (x != y && x != y + 3 && x != y - 3)
        {
                yyerror("Error type mismatch\n");
                return false;
        }
        return true;
}

bool assign(char* variableName, int lhsType, int rhsType)
{
	int x = existandInitialized(variableName);
	if(x == -1) {
                yyerror("Error variable is not declared \n"); 
                return false;
        }

	if(!validateAssign(lhsType, rhsType,false)) return false; 

	if(lhsType >=3 && x == 1) {
                yyerror("Error const variable is already initialized\n");
                return false;
        }
        return true;
}

void yyerror(char *s) {
        fprintf(errorFile, "%s", s);
}

int main(void) {
        errorFile= fopen("errortest.txt", "w");
	
	if (errorFile == NULL)
        {
                printf("Error opening errortest.txt file!\n");
                exit(1);
        }
        assembly= fopen("AssemblyCode.txt", "w");
	
	if (assembly == NULL)
        {
                printf("Error opening assembly file!\n");
                exit(1);
        }

	fprintf(assembly,"## \t Generated Code \t ##");

        testFile = fopen("test3.txt", "r");
        if (testFile == NULL)
        {
                printf("Error opening test file!\n");
                exit(1);
        }

	yyin = testFile;

	do {
		yyparse();
       
	} while (!feof(yyin));
        yyparse();
        return 0;
}
