# Spring 2020 Milestone 2
# Test file 4
# Tests:  - add, addi, beq, bne, la, lw, mul, nor, syscall
#         - integer values in data segment
#         - array in data segment
# Maximum score: 23.0

.data
list01: .word  -342143:6
val01:  .word  4132343

.text
        la   $s0, list01
        la   $s2, val01
        lw   $s4, 0($s1)
        add  $s1, $zero, $s0
        mul  $s3, $s1, $s2

        beq  $zero, $zero, test
again:
        mul  $s4, $s1, $s1
        lw   $s4, -16($s4)
        nor  $s3, $s3, $s4
        beq  $s3, $zero, exit
        lw   $s0, 42($s1)
test:
        bne  $s1, $s2, again
        beq  $s1, $s4, again
exit:
        addi $v0, $zero, 10
        syscall
