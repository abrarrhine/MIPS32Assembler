# Spring 2020 Full Assembler
# Test file 10
# Tests:  - comprehensive test of all instructions
#         - full-featured data segment
#         - full-line comments
#         - end-of-line comments
#
# Maximum points:  60.0

.data
x01:    .word    14324143
s01:    .asciiz  "a"
x02:    .word    -323434
s02:    .asciiz  "ab"
x03:    .word    873124
s03:    .asciiz  "abc"
x04:    .word    -1343241
s04:    .asciiz  "abcd"
arr01:  .word    23:6
s05:    .asciiz  "How did that one go?"
arr02:  .word    6, 28, 496, 8128

.text
main:
        la     $t0, arr01          # get address of first array
        lw     $t1, x01            # load value of x01
        sw     $t1, 4($t1)         # store value of x01 into arr01[1]
        lui    $t1, -1             # load 0xFFFF to top half of $t1

# Check basic R-type and I-type instructions
label1:
        add    $t4, $t2, $t3
        addi   $s0, $s0, 31214
        addu   $s1, $s1, $s2
        addiu  $s2, $s2, -31214
        mul    $s3, $s4, $s5
        mult   $s3, $s4
label2:
        mul    $t4, $t7, $t9
        nop
        nor    $t3, $t6, $t8
        sll    $s2, $s2, 31
        slt    $t3, $s2, $s3
        slti   $t3, $s2, -21497
label3:
        sra    $s0, $s1, 17
        srav   $s7, $s2, $s0
        sub    $t0, $zero, $s1

# Check some conditional branch instructions and j
        beq    $t1, $a0, label1
        blez   $t3, label2
        bgtz   $s7, label3
        bne    $s5, $zero, label2
        j      label1
# Check remaining pseudo-instructions, and syscall
label4:
        move   $t3, $s3
        blt    $t0, $t1, label4
        li     $t3, -4123
        syscall

# Load addresses of selected variables
# These check the alignment, which and therefore padding
        la     $t3, x02
        la     $t3, x03
        la     $t3, x04
        la     $t3, s05
        la     $t3, arr02
