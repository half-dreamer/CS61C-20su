.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
	
    # other initialization
    mv s0, a0   # s0 is a0
    mv s1, a1   # s1 is a1
    mv s2, a2   # s2 is a2

    # call fopen 
    mv a1, s0
    li a2, 0    # 'r' mode
    
    jal fopen

    li t0, -1   # fopen error code
    beq a0, t0, fopen_error # if a0 == t0 then fopen_error
    mv s3, a0   # s3 is the file descriptor
    
    # call fread to read the number of rows
    mv a1, s3
    mv a2, s1
    li a3, 4    # read 4 bytes(1 word)

    jal fread

    li t0, 4    # shoule output 4 (read in 4 bytes)
    bne a0, t0, fread_error

    # call fread to read the number of columns
    mv a1, s3
    mv a2, s2
    li a3, 4    # read 4 bytes(1 word)

    jal fread

    li t0, 4    # shoule output 4 (read in 4 bytes)
    bne a0, t0, fread_error

    # now we read in the number of rows and columns

    # get the number of rows and columns
    lw s4, 0(s1)    # s4 is the number of rows
    lw s5, 0(s2)    # s5 is the number of columns
    mul s6, s4, s5  # s6 is the total number of elements to read in 

    # malloc s6(number of elements) words memory (i.e. 4 * s6 bytes)
    li t0, 4
    mul a0, s6, t0 # a0 is 4 * s6 

    jal malloc      # TODO: I don't know the error code of malloc

    mv s7, a0   # s7 is the pointer of allocated heap memory
    
    li t0, 0    # t0 is 'i',initialized to 0
    li t1, 4    # t1 is 4, 4 bytes a word
    # the loop for read all elements 
loop_read_elements:
    bge t0, s6, read_ele_end # if t0 >= s6 then read_ele_end

    mul t2, t0, t1  # t2 is 4 * i
    add t3, s7, t2  # t3 is pointer + 4 * i, i.e. the address to store the element

    # call fread to read in element 
    # prologue
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)

    mv a1, s3
    mv a2, t3
    li a3, 4    # read 4 bytes(1 word)

    jal fread

    li t0, 4    # shoule output 4 (read in 4 bytes)
    bne a0, t0, fread_error

    # epilogue
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    addi sp, sp, 16

    addi t0, t0, 1  # i++
    j loop_read_elements


read_ele_end:
    mv a1, s3
    jal fclose
    li t0, -1   # fclose error exit code
    beq a0, t0, fclose_error

    mv a0, s7

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 36
	

    ret
    
fopen_error:
    li a1, 50
    jal exit2    

fread_error:
    li a1, 51
    jal exit2    

fclose_error:
    li a1, 52
    jal exit2    