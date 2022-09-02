.global _start
.align 2
_start:
        mov x0, 1
        mov x1, 2
        mov x2, 1
        mov x0, #1000
        mul x0, x0, x0
        mul w1, w1, w2
        mul w1, w1, w2
        mul w1, w1, w2
        mul w1, w1, w2
        mul w1, w1, w2
        mul w1, w1, w2
        mul w1, w1, w2
        add x3, x3, #1
        cmp x3, x0
        bne _start+0x14
        add x5, x5, #48
        ldr x6, =num
        str x5, [x6]
        mov x0, #1
        ldr x1, =num
        mov x2, #1
        mov x8, #64
        svc #0
        mov x0, #0
        mov x8, #94
        svc #0
.data
num:
        .ascii " "
