# Makefile for SPL-compiler
clean:
	rm -rf *.o
	rm lex.yy.c
	rm y.tab.c

# To compile your file lexan.l --> lexer
# 
lexer:  lex.yy.o mainlexer.o printtoken.o token.h lexan.h
	cc -o lexer lex.yy.o mainlexer.o printtoken.o

mainlexer.o: mainlexer.c token.h lexan.h
	cc -c mainlexer.c

lex.yy.o: lex.yy.c
	cc -c lex.yy.c

lex.yy.c: lexan.l token.h
	lex lexan.l

printtoken.o: printtoken.c token.h
	cc -c printtoken.c


# To compile your file parse.y --> parser
#      using your file lexan.l
parser: mainparser.o parsefun.o y.tab.o lex.yy.o printtoken.o pprint.o symtab.o
	cc -o parser mainparser.o parsefun.o y.tab.o lex.yy.o printtoken.o pprint.o symtab.o -ll

mainparser.o: mainparser.c token.h parse.h symtab.h lexan.h pprint.h
	cc -c mainparser.c

parsefun.o: parsefun.c token.h parse.h symtab.h lexan.h pprint.h
	cc -c parsefun.c

y.tab.o: y.tab.c
	cc -c y.tab.c

y.tab.c: parse.y token.h parse.h symtab.h lexan.h
	yacc parse.y

pprint.o: pprint.c token.h pprint.h
	cc -c pprint.c

symtab.o: symtab.c token.h symtab.h
	cc -c symtab.c



# To compile your file codegen.c --> compiler
#      using your files lexan.l and parse.y
compiler: maincompiler.o parsefun.o y.tab.o lex.yy.o printtoken.o pprint.o symtab.o codegen.o genasm.o
	cc -o compiler maincompiler.o parsefun.o y.tab.o lex.yy.o printtoken.o pprint.o symtab.o \
             codegen.o genasm.o

maincompiler.o: maincompiler.c token.h parse.h symtab.h lexan.h symtab.h genasm.h
	cc  -c maincompiler.c

genasm.o: genasm.c token.h symtab.h genasm.h
	cc -c genasm.c

codegen.o: codegen.c token.h symtab.h genasm.h
	cc -c codegen.c

