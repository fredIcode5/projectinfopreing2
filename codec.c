#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct chainon{
    int ID;
    unsigned long cap;
    unsigned long conso;
}Chainon;

typedef struct tree{
    Chainon* c;
    struct tree* pLeft;
    struct tree* pRight;
    int balance;
}Tree;

int max2(int v1, int v2){
    if(v1 > v2){
        return v1;
    }
    return v2;
}

int min2(int v1, int v2){
    if(v1 < v2){
        return v1;
    }
    return v2;
}

int max3(int v1, int v2, int v3){
    return max2(v1, min2(v2, v3));
}

int min3(int v1, int v2, int v3){
    return min2(v1, min2(v2, v3));
}

Chainon* createChainon(int id, unsigned long CAP, unsigned long CONSO){
    Chainon* new = malloc(sizeof(Chainon));
    if(new == NULL){
        exit;
    }
    new->ID = id;
    new->cap = CAP;
    new->conso = CONSO;
    return new; 
}

Tree* createAVL(Chainon* c){
    Tree* pRoot = malloc(sizeof(Tree));
    if(pRoot == NULL){
        exit;
    }
    pRoot->c = c;
    pRoot->pLeft = NULL;
    pRoot->pRight = NULL;
    pRoot->balance = 0;
    return pRoot;
}

Tree* rotateLeft(Tree* pRoot){
    if(pRoot == NULL  || pRoot->pRight == NULL){
        exit;
    }
    Tree* pPivot = pRoot->pRight;
    pRoot->pRight = pPivot->pLeft;
    pPivot->pLeft = pRoot;
    int eqa = pRoot->balance;
    int eqp = pPivot->balance;
    pRoot->balance = eqa - max2(eqp, 0) - 1;
    pPivot->balance = min3(eqa-2, eqa+eqp-2, eqp-1);
    pRoot = pPivot;
    return pRoot;
}

Tree* rotateRight(Tree* pRoot){
    if(pRoot == NULL || pRoot->pLeft == NULL){
        exit;
    }
    Tree* pPivot = pRoot->pLeft;
    pRoot->pLeft = pPivot->pRight;
    pPivot->pRight = pRoot;
    int eqa = pRoot->balance;
    int eqp = pPivot->balance;
    pRoot->balance = eqa - min2(eqp, 0) + 1;
    pPivot->balance = max3(eqa+2, eqa+eqp+2, eqp+1);
    pRoot = pPivot;
    return pRoot;
}

Tree* doubleRotateLeft(Tree* pRoot){
    if(pRoot == NULL || pRoot->pRight == NULL){
        exit;
    }
    pRoot->pRight = rotateRight(pRoot->pRight);
    return rotateLeft(pRoot);
}

Tree* doubleRotateRight(Tree* pRoot){
    if(pRoot == NULL || pRoot->pLeft == NULL){
        exit;
    }
    pRoot->pLeft = rotateLeft(pRoot->pLeft);
    return rotateRight(pRoot);
}

Tree* balanceAVL(Tree* pRoot){
    if(pRoot == NULL){
        exit;
    }
    if(pRoot->balance >= 2){
        if(pRoot->pRight == NULL){
            exit;
        }
        if(pRoot->pRight->balance >=0 ){
            pRoot = rotateLeft(pRoot);
        }
        else{
            pRoot = doubleRotateLeft(pRoot);
        }
    }
    if(pRoot->balance <= -2){
        if(pRoot->pLeft == NULL){
            exit;
        }
        if(pRoot->pLeft->balance <= 0){
            pRoot = rotateRight(pRoot);
        }
        else{
            pRoot = doubleRotateRight(pRoot);
        }
    }
    return pRoot;
}

Tree* insertAVL(Tree* pRoot, Chainon* c, int* h){
    if(pRoot == NULL){
        *h = 1;
        pRoot = createAVL(c);
        if(pRoot == NULL){
            exit;
        }
        return pRoot;
    }
    else if(c->ID < pRoot->c->ID){
        pRoot->pLeft = insertAVL(pRoot->pLeft, c, h);
        *h = -*h;
    }
    else if(c->ID > pRoot->c->ID){
        pRoot->pRight = insertAVL(pRoot->pRight, c, h);
    }
    else{
        *h = 0;
        pRoot->c->cap = pRoot->c->cap + c->cap;
        pRoot->c->conso = pRoot->c->conso + c->conso;
        return pRoot;
    }
    if(*h != 0){
        pRoot->balance = pRoot->balance + *h;
        pRoot = balanceAVL(pRoot);
        if(pRoot->balance == 0){
            *h = 0;
        }
        else{
            *h = 1;
        }
    }
    return pRoot;
}

void infix(Tree* p){
    if(p != NULL){
        infix(p->pLeft);
        printf("[%02d(%2d)]", p->c->ID, p->balance);
        printf("cap = %d conso = %d\n", p->c->cap, p->c->conso);
        infix(p->pRight);
    }
}

void remplissage(Tree* pRoot, FILE* file){
    if(pRoot != NULL){
        remplissage(pRoot->pLeft, file);
        fprintf(file, "%d:%d:%d\n", pRoot->c->ID, pRoot->c->cap, pRoot->c->conso);
        remplissage(pRoot->pRight, file);
    }
}

int main(){
    printf("ça marche");
    Chainon* new;
    Tree* AVL;
    int id, h=0;
    unsigned long CAP, CONSO;
    while(scanf("%d;%lu;%lu\n", &id, &CAP,&CONSO) == 3){
        new = createChainon(id, CAP, CONSO);
        AVL = insertAVL(AVL, new, &h);
    }
    infix(AVL);
    printf("\n");

   FILE* file;
   file = fopen("resultat.csv","w");
    if (file == NULL){
       exit;
   }
    fprintf(file, "ID:cap:conso\n");
    remplissage(AVL, file);
    printf("Fichier CSV créé avec succès : data.csv\n");
    return 0;
}