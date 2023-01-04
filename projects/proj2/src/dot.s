.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
    li t0, 1
    blt a2, t0, exit_5 # if a2 < t0 then exit_5
    blt a3, t0, exit_6
    blt a4, t0, exit_6

    # Prologue
    addi sp, sp, -12
    sw  s0, 0(sp)
    sw  s1, 4(sp)
    sw  s2, 8(sp)

    # other initialization
    li  t0, 0   # t0 is the 'i'
    li  s0, 0   # s0 is the sum of dot product
    li  t6, 4   # remember to add this! 4 bytes a word

loop_start:
    bge t0, a2, loop_end # if t0 >= a2 then loop_end
    mul s1, t0, a3  # s1 is i * v0 stride
    mul s2, t0, a4  # s2 is i * v1 stride
    mul s1, s1, t6
    mul s2, s2, t6
    add t1, a0, s1  # t1 is &(v1 array + 4 * i stride)   below this , all have 4 *
    add t2, a1, s2  # t2 is &(v1 array + i stride)
    lw  t3, 0(t1)   # t3 is *(v1 array + i stride)
    lw  t4, 0(t2)   # t4 is *(v2 array + i stride)
    mul t5, t3, t4  # t5 is *(v1 array + i stride) mul *(v2 array + i stride)
    add s0, s0, t5
    addi t0, t0, 1  # i++
    j loop_start  # jump to loop_start

loop_end:
    mv  a0, s0

    # Epilogue
    lw  s0, 0(sp)
    lw  s1, 4(sp)
    lw  s2, 8(sp)
    addi sp, sp, 12

    ret


exit_5:
    li a1, 5
    j exit2

exit_6:
    li a1, 6    
    j exit2