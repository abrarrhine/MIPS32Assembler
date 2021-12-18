# Spring 2020 Milestone 2
# Test file 3
# Tests:  - integer values in data segment
#         - array in data segment
#         - la and lw instructions
# Maximum score: 20.0

.data
val01:  .word  31
list01: .word  42:6

.text
       la   $s0, val01
       la   $s1, list01

       lw   $s7, 0($s0)
       lw   $s6, 4($s1)
       lw   $s6, 8($s1)
       lw   $s5, 12($s1)
       lw   $s4, 20($s1)

       lw   $s5, -4($s1)
       lw   $s5, -8($s1)
       lw   $s5, -12($s1)

       lw   $s5, 32767($s1)
       lw   $s5, -32768($s1)
