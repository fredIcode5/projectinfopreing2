#include <stdio.h>
#include <stdlib.h>

typedef struct tree{
    int value;
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

Tree* createAVL(int v){
    Tree* pRoot = malloc(sizeof(Tree));
    if(pRoot == NULL){
        exit;
    }
    pRoot->value = v;
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

Tree* insertAVL(Tree* pRoot, int v, int* h){
    if(pRoot == NULL){
        *h = 1;
        pRoot = createAVL(v);
        if(pRoot == NULL){
            exit;
        }
        return pRoot;
    }
    else if(v < pRoot->value){
        pRoot->pLeft = insertAVL(pRoot->pLeft, v, h);
        *h = -*h;
    }
    else if(v > pRoot->value){
        pRoot->pRight = insertAVL(pRoot->pRight, v, h);
    }
    else{
        *h = 0;
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

Tree* suppMinAVL(Tree* pRoot, int* h, int* pe){
    if(pRoot->pLeft == NULL){
        *pe = pRoot->value;
        *h = -1;
        Tree* tmp = pRoot;
        pRoot = pRoot->pRight;
        free(tmp);
        return pRoot;
    }
    else{
        pRoot->pLeft = suppMinAVL(pRoot->pLeft, h, pe);
        *h =-*h;
    }
    if(*h != 0){
        pRoot->balance = pRoot->balance+*h;
        if(pRoot->balance == 0){
            *h = -1;
        }
        else{
            *h = 0;
        }
    }
    return pRoot;
}

Tree* removeAVL(Tree* pRoot, int v, int* h){
    if(pRoot == NULL){
        *h = 1;
        return pRoot;
    }
    if(v < pRoot->value){
        pRoot->pLeft = removeAVL(pRoot->pLeft, v, h);
        *h = -*h;
    }
    else if(v > pRoot->value){
        pRoot->pRight = removeAVL(pRoot->pRight, v, h);
    }else if(pRoot->pRight != NULL){
        pRoot->pRight = suppMinAVL(pRoot->pRight, h, &(pRoot->value));
    }
    else{
        Tree* tmp = pRoot;
        pRoot = pRoot->pRight;
        free(tmp);
        *h = -1;
        return pRoot;
    }
    if(*h != 0){
        pRoot->balance = pRoot->balance+*h;
        if(pRoot->balance == 0){
            *h = -1;
        }
        else{
            *h = 0;
        }
    }
    return pRoot;
}

void infix(Tree* p){
    if(p != NULL){
        infix(p->pLeft);
        printf("[%02d(%2d)]", p->value, p->balance);
        infix(p->pRight);
    }
}