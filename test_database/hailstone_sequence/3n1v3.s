.global _start
.align 2
_start:
        mov x9, #1000
        mul x9, x9, x9
        mov x10, #0
        mov x7, #5
        cmp x7, #1
        beq _end
        tst x7, #1
        bne _odd
        mov x5, #2
        udiv x4, x7, x5
        mov x7, x4
        b _start+0x10
_odd:
        mov x6, #3
        mul x3, x7, x6
        add x7, x3, #1
        b _start+0x10
_end:
        add x10, x10, #1
        cmp x10, x9
        bne _start+0xc
        mov x0, #0
        mov x8, #94
        svc #0

