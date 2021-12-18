# Spring 2020 Milestone 2
# Test file 5
# Thorough test of handling labels and conditional branch instructions
# Tests:  - add, addi, beq, bne, la, lw, mul, mult, nor, syscall
#         - integer values in data segment
# Maximum score: 31.0

.data
A:  .word  -32768
B:  .word    -255
C:  .word     255
D:  .word   32767

.text
        la   $s0, A
        lw   $s1, 0($s0)
        la   $s0, B
        lw   $s2, 0($s0)
        la   $s0, C

Aberdeen:
        beq  $s1, $s2, Skye
        add  $s1, $s1, $s3
        beq  $s1, $s2, Culloden
        nor  $s1, $s3, $s1
        bne  $s1, $s3, Stirling
        add  $s1, $s1, $s3
        mult $s1, $s3
        beq  $s1, $s2, Aberdeen

Skye:
        mul  $s2, $s2, $s4
        bne  $s2, $s4, Craig
        addi $s2, $s2, 1023
        beq  $s1, $s2, Aberdeen

Stirling:
        bne  $s2, $s3, Aberdeen

Craig:
        add  $s3, $s4, $s1
        mult $s3, $s3
        beq  $s3, $s2, Skye
        beq  $s3, $s1, Culloden
        beq  $s3, $s4, Craig
        beq  $zero, $zero, Aberdeen

Culloden:
        addi $v0, $zero, 10
        syscall
