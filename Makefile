build:
	yacc -d y.y
	lex lex.l
	gcc lex.yy.c y.tab.c symbolTable.h -obas.exe

clean:
	rm -f lex.yy.c y.tab.c y.tab.h bas.exe

all: clean build

run:
	./bas.exe > outputTest.txt
