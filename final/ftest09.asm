# Spring 2020 Full Assembler
# Test file 9
# Tests:  - array and integer in data segment
#         - la, lw, sw
#         - end-of-line comments
#
# Maximum points:  30.0

.data
dim01:  .word   4
arr01:  .word   -1:4
dim02:  .word   17
arr02:  .word   2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 51

.text
main:
        la   $t0, arr01      # $t0 points to arr01[0]
        lw   $s1, dim01
        lw   $s2, 8($t0)

        la   $t1, arr02      # $t1 points to arr02[0]
        lw   $s3, dim02
        sw   $s1, 24($t0)
        sw   $s2, 24($t0)
