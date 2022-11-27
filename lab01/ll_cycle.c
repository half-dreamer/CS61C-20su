#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *hare = head,*torroise = head;
    int startFlag = 1;
    while(1) {
    if (hare == NULL || hare->next == NULL || hare->next->next == NULL) {
        return 0;
    } else if(hare == torroise && !startFlag) {
        return 1;
    } else {
        hare = hare->next->next;
        torroise = torroise -> next;
        startFlag = 0;
    }
    }
}