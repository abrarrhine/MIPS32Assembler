# Spring 2020 Assembler Milestone 1
# m1_01.asm
#
# Test R-format:  add, nor
# Maximum score:  6.0

.text
main:
        add   $s0, $s1, $s2
        add   $s3, $s4, $s5
        add   $s6, $s7, $v0

        nor   $v1, $s3, $s5
        nor   $s1, $s6, $v0
        nor   $s3, $s5, $s0
