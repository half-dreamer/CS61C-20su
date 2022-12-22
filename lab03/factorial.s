.globl factorial

.data
n: .word 7

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    # a0 is the argument
    # use iterative solution 

    #because we use the t1 register and a0,so we need to store them
    #but the a0 is the return value,so we don't have to store it 
    addi sp, sp, -4
    sw t0, 0(sp)

    addi t0, x0, 1  # t0 is product(now is 1)
loop: mul  t0, t0, a0
    addi a0, a0, -1
    bgt  a0, x0, loop # if a0 > 0 then factorial
    addi a0, t0, 0         # store product into a0 (return value)

    lw t0, 0(sp)
    addi sp, sp, 4
    jr   ra
     