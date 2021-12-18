# Spring 2020 Full Assembler
# Test file 1
# Tests:  - R-type: add, addu, mul, nor, sll, slt, sra
#         - integer-only data segment
#         - no data accesses
# Maximum points:  12.0

.data
val01:  .word  65535
val02:  .word  -4134137

.text
main:
        # basic 3-register operand versions
        add  $s0, $s1, $s2
        nor  $s6, $s7, $v0
        addu $v1, $t0, $t1
        slt  $t2, $t3, $t4
        sub  $t5, $t6, $t7

        # 3 registers, but special opcode case
        mul  $at, $k0, $k1

        # 2 registers and a shift amount
        sra  $t8, $t9, 15
        sll  $a0, $a1, 23

        # 2 registers, special operand case
        mult $t7, $s3
