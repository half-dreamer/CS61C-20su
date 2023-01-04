.import ../../src/dot.s
.import ../../src/utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
    mv a0, s0
    mv a1, s1
    li a2, 9
    li a3, 1
    li a4, 1

    # Call dot function
    jal dot

    # Print integer result
    mv a1, a0
    jal  print_int

    # Print newline
    li a1, '\n'
    jal print_char

    # Exit
    jal exit
