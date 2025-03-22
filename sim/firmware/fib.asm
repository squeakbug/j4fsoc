.option norvc
.section .text
.type _entry, @function
.global _entry
_entry: 
    mv    t0, zero     # t0 = 0
    li    t1, 1        # t1 = 1
    mv    a0, t1       # a0 = t1

fib:                   # a0(i) = a0(i - 1) + a0(i - 2)
    add   t0, t0, t1   # t0 = t0 + t1
    mv    a0, t0       # a0 = t0
    add   t1, t0, t1   # t1 = t0 + t1
    mv    a0, t1       # a0 = t1
    beqz  zero,  fib
