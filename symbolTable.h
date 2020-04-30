//#pragma once
#include "uthash.h"
#include <stdbool.h>
#include <stdio.h>
#define MAX_IDENTIFER_LENGTH 20

enum data_type
{TYPE_INTEGER,      //0
 TYPE_FLOAT,        //1 
 TYPE_CHAR,         //2
 TYPE_CONST_INTEGER,//3
 TYPE_CONST_FLOAT,  //4
 TYPE_CONST_CHAR,   //5
};


struct variable {
	char variableName[MAX_IDENTIFER_LENGTH];  // key 
	enum data_type type;
	bool initialized; 
	UT_hash_handle hh; 
};

struct variable* symbolTable = NULL; 

char* getTypeName(enum data_type type) {
	switch (type) {
	case TYPE_INTEGER: return "int";
	case TYPE_FLOAT: return "float";
	case TYPE_CHAR:	return "char";
	case TYPE_CONST_INTEGER: return "const int";
	case TYPE_CONST_FLOAT: return "const float";
	case TYPE_CONST_CHAR:	return "const char";
	}
}


void printSymbolTable()
{
	printf("\n-------------------PRINTING SYMBOL TABLE--------------------\n");
	printf("Variable\t Type \t\tHas Value \n");
	printf("------------------------------------------------------------\n");
	struct variable *v;

	for (v = symbolTable; v != NULL; v = (struct variable*)(v->hh.next)) {
		printf("%s\t\t %s\t\t %s\t\t\n", v->variableName, getTypeName(v->type), v->initialized? "True" : "False");
	}
	printf("\n");
}

bool addVariable(char* variableName, enum data_type type)
{
	struct variable * v;
	HASH_FIND_STR(symbolTable, variableName, v);
	if (v != NULL)	return false;

	struct variable* newVariable;
	newVariable = (struct variable*)malloc(sizeof(struct variable));
    strcpy(newVariable->variableName, variableName);
	newVariable->initialized = false;
	newVariable->type = type;

	HASH_ADD_STR(symbolTable, variableName, newVariable);
	printf("Added Successfully \n");
    return true;
}

int existandInitialized (char* variableName)
{
	struct variable * v;
	HASH_FIND_STR(symbolTable, variableName, v);
	if (v == NULL)	return -1;				// Not Exist
	if (!v->initialized) return 0;			// Exist but not initialized
	return 1;
}

int getType(char* variableName) {
	
	struct variable * v;
	HASH_FIND_STR(symbolTable, variableName, v);
	if (v != NULL) {
		return v->type;
	}
	else {
		return -1;
	}
}


bool setVariable(char* variableName) {
	struct variable * v;

	HASH_FIND_STR(symbolTable, variableName, v);
	if (v == NULL)  return false;
	v->initialized = true;
	return true;
}

