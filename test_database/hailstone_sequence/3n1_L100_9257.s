.global _start
.align 2
_start: 
	mov x9, #10
	mul x9, x9, x9
	mov x10, #0
_loop:
	mov x7, #9257
	
        cmp x7, #1
        beq _end
        tst x7, #1
        beq _even
        bne _odd
_even:
        mov x6, #2
        udiv x4, x7, x6
        mov x7, x4
        b _loop+0x4
_odd:
        mov x5, #3
        mul x3, x7, x5
        add x7, x3, #1
        b _loop+0x4
_end:
	add x10, x10, #1
	cmp x10, x9
	bne _loop
        mov x0, #0
        mov x8, #94
        svc #0
.data
num:
        .ascii " "
_data: 
	.word 8,8,9,9,9,9,9,9,9
