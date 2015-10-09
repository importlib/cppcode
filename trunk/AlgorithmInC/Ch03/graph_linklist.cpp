#include <stdio.h>
#include <stdlib.h>
typedef struct node *link;
struct node
{
    int v;
    link next;
};
link NEW(int v, link next)
{   link x = (link)malloc(sizeof *x);
    x->v = v;
    x->next = next;
    return x;
}
#define V 100
int main()
{   int i, j;
    link adj[V];
    for (i = 0; i < V; i++) adj[i] = NULL;
    while (scanf("%d %d\n", &i, &j) == 2)
    {
        adj[j] = NEW(i, adj[j]);
        adj[i] = NEW(j, adj[i]);
    }
}