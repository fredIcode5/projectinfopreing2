#ifndef PASSERELLE_H_INCLUDED
#define PASSERELLE_H_INCLUDED

#include<stdio.h>
#include<stdlib.h>
#include <time.h>

typedef struct chainon{
    int ID;
    long long cap;
    long long conso;
}Chainon;

typedef struct tree{
    Chainon* c;
    struct tree* pLeft;
    struct tree* pRight;
    int balance;
}Tree;


int max2(int v1, int v2);
int min2(int v1, int v2);
int max3(int v1, int v2, int v3);
int min3(int v1, int v2, int v3);
Chainon* createChainon(int id, long long CAP, long long CONSO);
Tree* createAVL(Chainon* c);
Tree* rotateLeft(Tree* pRoot);
Tree* rotateRight(Tree* pRoot);
Tree* doubleRotateLeft(Tree* pRoot);
Tree* doubleRotateRight(Tree* pRoot);
Tree* balanceAVL(Tree* pRoot);
Tree* insertAVL(Tree* pRoot, Chainon* c, int* h);
void infix(Tree* p);
void libererEspace(Tree* p);

#endif // PASSERELLE_H_INCLUDED