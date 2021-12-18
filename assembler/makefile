assembler: assembler.o Function.o Opcode.o Register.o Label.o
	gcc -o assemble -std=c11 -Wall -W -ggdb3 assembler.o Function.o Opcode.o Register.o Label.o

assembler.o: assembler.c assembler.h Function.h Opcode.h Register.h
	gcc -c -std=c11 -Wall -W -ggdb3 assembler.c
Function.o: Function.c Function.h
	gcc -c -std=c11 -Wall -W -ggdb3 Function.c
Opcode.o: Opcode.c Opcode.h
	gcc -c -std=c11 -Wall -W -ggdb3 Opcode.c
Register.o: Register.c Register.h
	gcc -c -std=c11 -Wall -W -ggdb3 Register.c
Label.o: Label.c Label.h
	gcc -c -std=c11 -Wall -W -ggdb3 Label.c
clean:
	rm *.o assemble
