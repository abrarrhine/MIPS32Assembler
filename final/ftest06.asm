# Spring 2020 Full Assembler
# Test file 6
# Tests:  - la and lw
#         - short strings in data segment; some alignment padding
# Maximum points:  20.0

.data
str01:  .asciiz  "abc"
str02:  .asciiz  "back"
str03:  .asciiz  "to"
str04:  .asciiz  "end"
str05:  .asciiz  "Assembling machine code is fun, and good for you!"

.text
main:
        la    $t0, str01
        lw    $s0, 0($t0)
