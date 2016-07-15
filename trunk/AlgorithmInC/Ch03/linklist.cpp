#include <stdio.h>
#include <stdlib.h>
typedef struct node* link;
struct node {
    int item;
    link next;
};
int main(int argc, char *argv[])
{   int i, N = atoi(argv[1]), M = atoi(argv[2]);
    link t = (link)malloc(sizeof *t), x = t;
    t->item = 1;
    t->next = t;
    for (i = 2; i <= N; i++)
    {
        x = (x->next = (link)malloc(sizeof *x));
        x->item = i;
        x->next = t;
    }
    while (x != x->next)
    {
        for (i = 1; i < M; i++) x = x->next;
        x->next = x->next->next;
        N--;
    }
    printf("%d\n", x->item);
}

link reverse(link x)
{   link t, y = x, r = NULL;
    while (y != NULL)
    {
        t = y->next;
        y->next = r;
        r = y;
        y = t;
    }
    return r;
}