#include "passerelle.h"

int main(){
    Chainon* new;
    Tree* AVL;
    int id, h=0;
    long long CAP, CONSO;
    while(scanf("%d;%lld;%lld\n", &id, &CAP,&CONSO) == 3){
        new = createChainon(id, CAP, CONSO);
        AVL = insertAVL(AVL, new, &h);
    }
    infix(AVL);
    return 0;
}
