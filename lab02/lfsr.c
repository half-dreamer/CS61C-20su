#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"
#include "bit_ops.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    unsigned int shiftInNum = get_bit(*reg,0) ^ get_bit(*reg,2) ^ get_bit(*reg,3) ^ get_bit(*reg,5);
    *reg >>= 1;
    *reg += shiftInNum << 15;
}

