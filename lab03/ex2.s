.data
source:
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
main:
    addi t0, x0, 0
    addi s0, x0, 0      #s0 is the sum
    la s1, source       #s1 is the source pointer
    la s2, dest         #s2 is the dest pointer 
loop:
    slli s3, t0, 2      #t0 is k,s3 is 4k, actually slli instruction is to multiplt k by 4,cause we
                        #need to manually calculate the translation between word and byte.
                        #.word store in 4 bytes, and the address need to add in multiple of 4
    add t1, s1, s3
    lw t2, 0(t1)        #t1 is &(source + k)  t2 is *(source + k) (aka,source[k])
    beq t2, x0, exit    #check for source[k] != 0
    add a0, x0, t2      #a0 is the argument to pass into the fun
    addi sp, sp, -8     #store t0,t2, because later we won't use t1,so we don't store it 
    sw t0, 0(sp)
    sw t2, 4(sp)
    jal square
    lw t0, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    add t2, x0, a0      #t2 is fun(source[k])
    add t3, s2, s3      #t3 is &(dest + k)
    sw t2, 0(t3)        #store;  i.e. desk[k] = t2
    add s0, s0, t2      # sum += t2
    addi t0, t0, 1      # k++
    jal x0, loop        # equal j loop
square: # i.e. the fun() 
    add t0, a0, x0
    add t1, a0, x0
    addi t0, t0, 1
    addi t2, x0, -1
    mul t1, t1, t2  # x * (x + 1)
    mul a0, t0, t1  # (-1)* x *(x + 1)
    jr ra           
exit:
    add a0, x0, s0
    add a1, x0, x0
    ecall # Terminate ecall