# Nom de l'exécutable
TARGET = programme

# Fichiers source
SRCS = main.c fonction.c

# Fichiers objets (générés à partir des sources)
OBJS = $(SRCS:.c=.o)

# Compilateur et options
CC = gcc
CFLAGS = -Wall -Wextra -std=c11

# Règle par défaut
all: $(TARGET)

# Règle pour créer l'exécutable
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

# Règle pour compiler les fichiers .c en fichiers .o
%.o: %.c passerelle.h
	$(CC) $(CFLAGS) -c $< -o $@

# Nettoyage des fichiers générés
clean:
	rm -f $(OBJS) $(TARGET)