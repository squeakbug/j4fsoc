.option norvc
.section .text._entry
.type _entry, @function
.global _entry
_entry:
    mv a0, zero              # t0 = 0

.globl counter
counter:
    addi a0, a0, 1           # t0 = t0 + 1
    beq zero, zero, counter  # if t0 == t1 then counter
