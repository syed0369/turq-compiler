CC     = gcc
CFLAGS = -g -Wall -Wno-unused-function
INPUT  = hello.tq

.PHONY: all clean run paren

all: turq

turq: y.tab.c y.tab.h lex.yy.c
	$(CC) $(CFLAGS) y.tab.c lex.yy.c -o turq

y.tab.c y.tab.h: yacc.y
	yacc -d yacc.y

lex.yy.c: lex.l y.tab.h
	lex lex.l

run: turq $(INPUT)
	./turq $(INPUT) > assembly.asm
	nasm -f elf64 assembly.asm -o object_file.o
	ld object_file.o -o executable
	@echo "Run echo '(())' | ./executable"

clean:
	rm -f turq lex.yy.c y.tab.c y.tab.h
	rm -f assembly.asm object_file.o executable
