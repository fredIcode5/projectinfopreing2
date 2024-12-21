all: exec clean

main.o: main.c passerellejo.h
	gcc -c main.c -o main.o

fonctions.o: fonctions.c passerellejo.h
	gcc -c fonctions.c -o fonctions.o

exec: main.o fonctions.o
	gcc *.o -o exec
	
clean:
	rm -f *.o
	