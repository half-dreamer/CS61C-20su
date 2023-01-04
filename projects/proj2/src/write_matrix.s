.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

	
    # other initialization
    mv s0, a0   # s0 is a0
    mv s1, a1   # s1 is a1
    mv s2, a2   # s2 is a2
    mv s3, a3   # s3 is a3

    # call fopen 
    mv a1, s0
    li a2, 1    # 'w' mode
    
    jal fopen

    li t0, -1   # fopen error code
    beq a0, t0, fopen_error # if a0 == t0 then fopen_error
    mv s4, a0   # s4 is the file descriptor

    # allocate memory space for the number of rows and use it for fwrite
    li a0, 4    # 4 bytes to store the number

    jal malloc

    sw s2, 0(a0)    # store the number of rows

    mv a1, s4
    mv a2, a0
    li a3, 1
    li a4, 4

    jal fwrite

    bne a0, a3, fwrite_error    # if a0 != a3, we get a fwrite error
    
    # allocate memory space for the number of columns and use it for fwrite
    li a0, 4    # 4 bytes to store the number

    jal malloc

    sw s3, 0(a0)    # store the number of columns

    mv a1, s4
    mv a2, a0
    li a3, 1
    li a4, 4

    jal fwrite

    bne a0, a3, fwrite_error    # if a0 != a3, we get a fwrite error
    
    # call fwrite to read the matrix
    mv a1, s4
    mv a2, s1
    mul a3, s2, s3  # the number of all elements to write is (row * column)
    li a4, 4    # 4 bytes a integer

    jal fwrite

    bne a0, a3, fwrite_error    # if a0 != a3 , we get a fwrite error

    # nothing to return , so we close the flie
    mv a1, s4

    jal fclose

    li t0, -1   # fclose error exit code
    beq a0, t0, fclose_error


    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
	
    ret
    
fopen_error:
    li a1, 53
    jal exit2    

fwrite_error:
    li a1, 54
    jal exit2    

fclose_error:
    li a1, 55
    jal exit2    