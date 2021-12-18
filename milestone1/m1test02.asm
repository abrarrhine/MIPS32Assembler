# Spring 2020 Assembler Milestone 1
# m1_02.asm
#
# Test I-format:  addi, slti
# Maximum score:  6.0

.text
main:
        addi  $s0, $s1, 63
        addi  $s3, $s4, -63
        addi  $s6, $s7, 4096

        slti  $v1, $s3, -4096
        slti  $s1, $s6, 13456
        slti  $s3, $s5, -13456
