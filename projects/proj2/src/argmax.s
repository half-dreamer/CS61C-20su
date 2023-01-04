.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -16
    sw  s0, 0(sp)
    sw  s1, 4(sp)
    sw  ra, 8(sp) # If I call any function, this will be neccessary
    sw  s2, 12(sp)
    sw  s3, 16(sp)


    # any other initialization
    li  t0, 0 # t0 is the 'i' 
    mv  s0, a0  # s0 is the array pointer
    mv  s1, a1  # s1 is the length of array
    li  t1, 4   # 4 bytes a word
    li  s2, -9999 # s2 stores the max value of array (try to store the mininum value I can store)
    li  s3, 0   # s3 stores the index of max value

loop_start:
    bge t0, s1, loop_end # if t0 >= s1 then loop_end
    mul t2, t0, t1  # t2 is 4 * i
    add t3, s0, t2  # t3 is &(array + i)
    lw  t4, 0(t3)   # t4 is *(array + i)
    mv  a0, t0
    bgt t4, s2, update_max # if t4 > s2 then update_maxIndex

loop_continue:
    addi t0, t0, 1  # i++
    j   loop_start


# input a0 is the current index which will replace the max value Index
update_max:
    mv  s2, t4
    mv  s3, a0
    j loop_continue  # jump to loop_continue

loop_end:
    mv  a0, s3

# Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    lw s2, 12(sp)    
    lw s3, 16(sp)
    addi sp, sp, 16

    ret