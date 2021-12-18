# Spring 2020 Milestone 2
# Test file 2
# Tests:  - some specified instructions from Milestone 1
#         - integer values in data segment
#         - array in data segment
# Maximum score: 16.0

.data
val01:   .word  0
val02:   .word  2147483647
val03:   .word  -2147483648
list01:  .word  15:8

.text
        addi $s0, $s1, -1

        nor  $s3, $s1, $s7

        slti  $v0, $s5, -32768
        syscall
