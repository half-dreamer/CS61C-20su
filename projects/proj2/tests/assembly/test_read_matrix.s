.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"
test1_path: .asciiz "inputs/simple1/bin/m0.bin"
test2_path: .asciiz "inputs/simple1/bin/m1.bin"
test3_path: .asciiz "inputs/simple1/bin/inputs/input0.bin"



# when calling assemble this file, remember to switch $CWD$ to tests dir
.text
main:
    # Read matrix into memory
    
    # first allocate two memory space for the number of rows and columns
    li a0, 4
    jal malloc 
    mv s1, a0   # s1 is the pointer of first allocated memory space 

    li a0, 4
    jal malloc 
    mv s2, a0   # s2 is the pointer of second allocated memory space

    # call read_matrix function
    la a0, file_path
    mv a1, s1
    mv a2, s2

    jal read_matrix

    mv s0, a0   # s0 is the pointer of the matrix 

    # Print out elements of matrix
    mv a0, s0
    lw a1, 0(s1)
    lw a2, 0(s2)

    jal print_int_array


    # Terminate the program
    jal exit