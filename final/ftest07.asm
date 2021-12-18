# Spring 2019 Full Assembler
# Test file 7
# Tests:  - la and lw
#         - mixed integers and strings in data segment
#         - some alignment padding
# Maximum points:  22.0

.data
str01:  .asciiz  "abc"
val01:  .word    839293
str02:  .asciiz  "backward"
val02:  .word    -839293
str03:  .asciiz  "to"
val03:  .word    903923
str04:  .asciiz  "end"
str05:  .asciiz  "Pointers are fun!"
val04:  .word    3137814

.text
main:
        la    $t0, val01
        la    $t1, val02
        la    $t2, val03

        lw    $s0, 0($t0)
        lw    $s1, 4($t1)

        sw    $s0, -40($t3)
