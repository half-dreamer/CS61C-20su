.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
# index    0            1         2          3             4   

    #TODO: remember to free memory space

    li t0, 5    # the number of correct command line arguments is 5
    bne a0, t0, wrong_num_args_error

    # prelogue
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    # other initialization
    # NOTE : I didn't store the a0(argc)
    mv s1, a1   # s1 is a1 (char**) argv
    mv s2, a2   # s2 is a2 , decide whether to print

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0

    # allocate memory space for int(number of rows or columns)
    li a0, 4
    jal malloc
    mv s3, a0   # s3 is the pointer of m0's row number 

    li a0,4
    jal malloc 
    mv s4, a0   # s4 is the pointer of m0's column number

    
    lw a0, 4(s1)    # <M0_PATH> pointer
    mv a1, s3
    mv a2, s4
    jal read_matrix
    mv s5, a0   # s5 is the pointer of m0 matrix



    # Load pretrained m1

    li a0, 4
    jal malloc
    mv s6, a0   # s6 is the pointer of m1's row number 

    li a0,4
    jal malloc 
    mv s7, a0   # s7 is the pointer of m1's column number

    
    lw a0, 8(s1)    # <M1_PATH> pointer
    mv a1, s6
    mv a2, s7
    jal read_matrix
    mv s8, a0   # s8 is the pointer of m1 matrix

    # Load input matrix

    li a0, 4
    jal malloc
    mv s9, a0   # s9 is the pointer of input's row number 

    li a0,4
    jal malloc 
    mv s10, a0   # s10 is the pointer of input's column number

    
    lw a0, 12(s1)    # <INPUT_PATH> pointer
    mv a1, s9
    mv a2, s10
    jal read_matrix
    mv s11, a0   # s11 is the pointer of input matrix

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # s3 is the pointer of m0's row number 
    # s5 is the pointer of m0 matrix
    # s6 is the pointer of m1's row number
    # s8 is the pointer of m1 matrix
    # s9 is the pointer of input's row number 
    # s11 is the pointer of input matrix

    # 1.  m0 * input (hidden_layer)
    # first , need to allocate memory space for the hidden layer
    li t0, 4
    lw t1, 0(s3)    # t1 is m0's row number
    lw t2, 0(s10)   # t2 is input's column number
    mul t3, t1, t2
    mul t3, t3, t0  # t3 is 4 * row(m0) * column(input)
    mv a0, t3
    jal malloc
    mv s0, a0   
    
    # matmul: m0 * input
    mv a0, s5
    lw a1, 0(s3)
    lw a2, 0(s4)
    mv a3, s11
    lw a4, 0(s9)
    lw a5, 0(s10)
    mv a6, s0   
    jal matmul
    # now s0 is really set as hidden layer (m0 * input)
    # s0 is the pointer of hidden layer

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    lw t0, 0(s3)    # t0 is the row number of m0    
    lw t1, 0(s10)   # t1 is the column number of input

    mv a0, s0
    mul a1, t0, t1  # a1 is the total number of elements in the hidden layer
    jal relu
    # now s0 get updated 
    # s0 is the pointer of ReLU(m0 * input)

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # allocate memory space for scores matrix
    li t0, 4
    lw t1, 0(s6)    # t1 is m1's row number 
    lw t2, 0(s10)   # t2 is input's column number
    mul t3, t1, t2
    mul t3, t3, t0  # t3 is 4 * m1 row_num * input col_num(or say,hidden layer col_num)
    mv a0, t3
    jal malloc
    mv s4, a0   # now s4 is the pointer of scores matrix

    # m1 * ReLU(m0 * input)
    mv a0, s8
    lw a1, 0(s6)
    lw a2, 0(s7)
    mv a3, s0
    lw a4, 0(s3)
    lw a5, 0(s10)
    mv a6, s4
    jal matmul
    # now s4 is pointer of real score matrix

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    # save the score matrix to output file(calling write_matrix function)
    lw a0, 16(s1)
    mv a1, s4
    lw a2, 0(s6)    # a2 is the row number of score matrix
    lw a3, 0(s10)   # a3 is the column number of score matrix
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s4
    lw t0, 0(s6)
    lw t1, 0(s10)
    mul a1, t0, t1
    jal argmax
    mv s9, a0   # s9 is the output of the argmax

    beq s2, x0, print_classification # if a2(s2) is 0,then print classification
    j end

    # Print classification
print_classification:
    mv a1, s9
    jal print_int
    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

end:
    # free previously allocated memory spaces
    mv a0, s5
    jal free
    mv a0, s8
    jal free
    mv a0, s11
    jal free
    mv a0, s0
    jal free
    mv a0, s4
    jal free

    mv a0, s9 # return value

    # epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52

    ret


wrong_num_args_error:
    li a1, 49
    jal exit2    