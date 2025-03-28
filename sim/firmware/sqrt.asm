.option norvc
.section .text
.type _entry, @function
.global _entry
init:
    li      a0, 0          ## calculation result reset
    li      a1, 82         ## x = 82
    li      t4, 1          ## shift amount for y >>= 1
    li      t5, 2          ## shift amount for y >>= 2

sqrt:   
    lui     t0, 0x40000    ## m = 0x40000000
    mv      t1, zero       ## y = 0

L0: 
    or      t2, t1, t0     ## b = y | m;
    srl     t1, t1, t4     ## y >>= 1
    sltu    t3, a1, t2     ## if (x < b)
    bnez    t3, L1         ##   goto L1
                           ## else
    sub     a1, a1, t2     ##   x -= b
    or      t1, t1, t0     ##   y |= m

L1: 
    srl     t0, t0, t5     ## m >>= 2
    bnez    t0, L0         ## if(m != 0) goto L0
    mv      a0, t1         ## return y

end:
    beqz    zero,  end     ## while(1);
