.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the total number of elements in the array (i.e. array.length())
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -12
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)

    # other initialization
    mv s0, a0
    mv s1, a1

len_test:
    li  t0, 1
    mv  t1, s1
    li  a1, 8
    bge t1, t0, loop_start   # If the length of array is less than 1, exit with error code 8
    # I find a subtle bug : B-instruction can't jump to global label!
    # e.g. If you use "blt t1, t0, exit2", then the error occurs, saying "it can't find the label exit2"
    j exit2

loop_start:
    # s0 is the pointer of array, s1 is the length of array
    li  t0, 0   # t0 is 'i'
loop_body:
    li  t4, 4
    bge t0, s1, loop_end # if t0 >= s1 then loop_end
    mul t5, t0, t4
    add t1, s0, t5 # t1 is &(array + 4*i)
    lw  t2, 0(t1)  # t2 is *(array + 4*i)

    mv  a0, t2
    ble t2, x0, nega_to_zero # if t2 <= x0 thnega_to_zero change_to_zero
loop_continue:
    mv  t2, a0
    sw  t2, 0(t1)   # store changed value into array

    addi t0, t0, 1  # i++
    j loop_body


# a0 is input value
nega_to_zero:
    li a0, 0 
    j loop_continue

loop_end:
    # Epilogue
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    addi sp, sp, 12
    
	ret