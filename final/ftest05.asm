# Spring 2020 Full Assembler
# Test file 5
# Tests:  - mixed R-type and I-type
#         - lw and sw data accesses
#         - la and li pseudos
#         - integer-only data segment
#         - no branches
# Maximum points:  22.0

.data
val01:  .word  0
val02:  .word  23
val03:  .word  -31
val04:  .word 2047
val05:  .word -8100

.text
main:
        la    $t0, val01
        la    $t1, val02
        lw    $s0, 0($t0)
        lw    $s1, 0($t1)
        lw    $s1, -4($t1)
        lw    $s1, 8($t0)
        lw    $s1, -13($t1)

        lui   $s3, 14783
        addi  $s3, $s3, -1
        nop
        slti  $s2, $s3, 0

        la    $t0, val05
        li    $s3, 28923
        sw    $s3, 4321($t0)
        sw    $s3, -8($t0)

        syscall
