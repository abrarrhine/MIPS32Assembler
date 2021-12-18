# Spring 2020 Full Assembler
# Test file 2
# Tests:  - mixed R-type, beq, bne, blez, bgtz, j, syscall
#         - integer-only data segment
#         - simple forward branches
#         - no data accesses
# Maximum points:  17.0

.data
val01:  .word  0

.text
main:
        # if-statement
        beq   $t0, $t1, over1
        addi  $s0, $s1, -7823
over1:

        # if-else statement
        bne   $t2, $t3, else1
        nor   $s6, $s7, $v0
        j     over2
else1:
        add   $v1, $t0, $t1
over2:

        # cascading if-elses
        blez  $s1, elif1
        slt   $t2, $t3, $t4
        j     over3
elif1:
        bgtz  $s3, elif2
        sub   $t5, $t6, $t7
        j     over3
elif2:
        mul  $at, $k0, $k1
over3:
        sll  $a0, $a1, 23

        syscall
