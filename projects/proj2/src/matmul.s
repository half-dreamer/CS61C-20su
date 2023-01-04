.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    li t0, 1
    # Error checks
    blt a1, t0, exit_2
    blt a2, t0, exit_2
    blt a4, t0, exit_3
    blt a5, t0, exit_3
    bne a2, a4, exit_4 # if a2 != a4 then exit_4

    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp) # because we will call dot function
    sw s0, 4(sp) # have 11 save registers in total
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    # other initialization
    li t0, 0 # t0 is i, i = 0   C[i][j]
    li t1, 0 # t1 is j, j = 0
    li t2, 4 # 4 bytes a word
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

# A (m x n) * B (n x k) = C (m x k)
# s1 is m , s2 is n , s4 is n , s5 is k
# remember to i++ and j++ !
    
outer_loop_start:
    bge t0, s1, outer_loop_end
    mul t3, t0, s2 #  i * n(column)
    mul t3, t3, t2 #  t3 is 4 * i * n
    add t3, s0, t3 #  t3 is the ith row address, &(&A + 4 * i * n)  

inner_loop_start:
    bge t1, s5, inner_loop_end
    mul t4, t2, t1 # 4 * j
    add t4, t4, s3 # t4 is the jth column address , &B + 4 * j

    # prologue
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)

    mv a0, t3
    mv a1, t4
    mv a2, s2
    li a3, 1
    mv a4, s5

    jal dot

    # epilogue 
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    addi sp, sp, 20

    mul t5, t0, s5  # k * i
    add t5, t5, t1  # j + k * i
    mul t5, t5, t2  # 4 * (i + k * j)
    add t5, t5, s6  # t5 is &C + 4 * (i + k * j) , i.e. the address to store the dot product
    sw a0, 0(t5)    # store dot product into proper position



    addi t1, t1, 1  # j++
    j  inner_loop_start  # jump to inner_loop_start

inner_loop_end:
    li t1, 0    # j = 0, after a inner loop
    addi t0, t0, 1 # i++
    j outer_loop_start  # jump to outer_loop_start
    
outer_loop_end:
    # Epilogue
    lw ra, 0(sp) # because we will call dot function
    lw s0, 4(sp) # have 11 save registers in total
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32

    ret

exit_2:
    li a1, 2
    j exit2    

exit_3:
    li a1, 3
    j exit2    

exit_4:
    li a1, 4
    j exit2    