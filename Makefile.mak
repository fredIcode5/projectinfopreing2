all: exec

main.o: main.c passerelle.h
	gcc -c main.c -o main.o

fonctions.o: fonctions.c passerelle.h
	gcc -c fonctions.c -o fonctions.o

exec: main.o fonctions.o
	gcc *.o -o exec

clean:
	rm -f *.o