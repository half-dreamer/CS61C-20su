    addi sp, sp, -12
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)
    add s0, a0, x0
    add s1, a1, x0
len_test:
    li  t0, 1
    add  t1, s1, x0
    li  a1, 8
    bge t1, t0, loop_start   # If the length of array is less than 1, exit with error code 8
    # I find a subtle bug : B-instruction can't jump to global label!
    # e.g. If you use "blt t1, t0, exit2", then the error occurs, saying "it can't find the label exit2"
    jal x0, exit2

loop_start:
    # s0 is the pointer of array, s1 is the length of array
    add  t0, x0, x0   # t0 is 'i'
loop_body:
    addi  t4, x0, 4
    bge t0, s1, loop_end # if t0 >= s1 then loop_end
    mul t5, t0, t4
    add t1, s0, t5 # t1 is &(array + 4*i)
    lw  t2, 0(t1)  # t2 is *(array + 4*i)

    add a0, t2, x0
    ble t2, x0, nega_to_zero # if t2 <= x0 thnega_to_zero change_to_zero
loop_continue:
    add  t2, a0, x0
    sw  t2, 0(t1)   # store changed value into array

    addi t0, t0, 1  # i++
    jal x0,loop_body


# a0 is input value
nega_to_zero:
    add a0, x0, x0
    jal x0,loop_continue

loop_end:
    # Epilogue
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    addi sp, sp, 12
    