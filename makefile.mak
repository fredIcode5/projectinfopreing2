all: C_WIRE

C-WIRE: main.o fonctions.o
	gcc -o C_WIRE main.o menu.o -o C_WIRE

main.o: main.c passerellejo.h
	gcc -c main.c -o main.o

fonctions.o: fonctions.c passerellejo.h
	gcc -c fonctions.c -o fonctions.o

clean:
	rm -f *.o
	rm -f C_WIRE