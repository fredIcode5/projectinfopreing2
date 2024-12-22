#include "passerelle.h"

// cherche la valeur la plus grande valeur entre v1 et v2
int max2(int v1, int v2){
    if(v1 > v2){
        return v1;
    }
    return v2;
}

// cherche la valeur la plus petite valeur entre v1 et v2
int min2(int v1, int v2){
    if(v1 < v2){
        return v1;
    }
    return v2;
}

// cherche la valeur la plus grande valeur entre v1 et v2 et v3
int max3(int v1, int v2, int v3){
    return max2(v1, max2(v2, v3)); // appelle la fonction max2 pour trouver la plus grande valeur entre v2 et v3 puis le max entre v1 et ce qui a été returner en par max2(v2,v3)
}

// cherche la valeur la plus petite valeur entre v1 et v2 et v3
int min3(int v1, int v2, int v3){
    return min2(v1, min2(v2, v3));
}

//creation d'un chainon pour AVL
Chainon* createChainon(int id, long long CAP, long long CONSO){
    Chainon* new = malloc(sizeof(Chainon));
    if(new == NULL){
        exit;
    }
    new->ID = id;
    new->cap = CAP;
    new->conso = CONSO;
    return new; 
}

//creer un noeud AVL avec la variable de type Chainon passer en paramètre
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

//fait une rotation simple vers la gauche
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

//fait une rotation simple vers la droite
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

//fait une rotation double vers la gauche
Tree* doubleRotateLeft(Tree* pRoot){
    if(pRoot == NULL || pRoot->pRight == NULL){
        exit;
    }
    pRoot->pRight = rotateRight(pRoot->pRight);
    return rotateLeft(pRoot);
}

//fait une rotation double vers la gauche
Tree* doubleRotateRight(Tree* pRoot){
    if(pRoot == NULL || pRoot->pLeft == NULL){
        exit;
    }
    pRoot->pLeft = rotateLeft(pRoot->pLeft);
    return rotateRight(pRoot);
}

//rééquilibre l'AVL passer en paramètre grace à l'indice d'équilibre de chaque noeud de l'arbre
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

//insert un noeud avec comme élément de type chainon dans l'AVL + appelle rééquilibrage si nécessaire
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

//affichage infix de sorte à ce que l'AVL soit afficher dans l'ordre croissant en fonction de l'ID des noeuds
void infix(Tree* p){
    if(p != NULL){
        infix(p->pLeft);
        printf("%d;%lld;%lld\n", p->c->ID, p->c->cap, p->c->conso);
        infix(p->pRight);
    }
}

void libererEspace(Tree* p){
    if(p != NULL){
        libererEspace(p->pLeft);
        libererEspace(p->pRight);
        free(p);
    }
}
