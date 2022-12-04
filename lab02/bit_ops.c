#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns
    // 0 or 1)
    unsigned int bitMask = 1;
    bitMask = bitMask << n  ;
    unsigned int maskedX = x & bitMask;
    return maskedX >> n;
    /* alternative solution
    return (x>>n) & 1;  
    */
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    // YOUR CODE HERE
    unsigned bitMask = ~(1 << n);
    *x = *x & bitMask; 
    unsigned AnotherBitMask = v << n;
    *x = *x | AnotherBitMask;
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    // YOUR CODE HERE
    unsigned FlipedNthBit = 1 ^ get_bit(*x,n);
    set_bit(x,n,FlipedNthBit); 
}

