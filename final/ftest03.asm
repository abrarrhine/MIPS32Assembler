# Spring 2020 Full Assembler
# Test file 3
# Tests:  - mixed R-type, addiu, beq, bne, blez, bgtz, j
#         - integer-only data segment
#         - simple backward branches
#         - no data accesses
# Maximum points:  10.0

.data
val01:  .word  101010

.text
main:
        # simple do-while loop
loop1:
        addiu  $s0, $s1, -4738
        beq    $t0, $t1, loop1
        sll    $s3, $s2, 16

        # nested do-while loops
loop2:
        srav   $v0, $s7, $t0
loop3:
        sub    $s3, $s4, $s5
        bgtz   $s6, loop3
        bne    $t2, $t3, loop2
        j      loop1
