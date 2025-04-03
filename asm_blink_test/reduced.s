.section .rodata
	.align	3
.LC0:
	.string	"/dev/gpiomem"
	.align	3
.text
	.align	2
	.global	main
main:
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	mov	w1, 4098
	movk	w1, 0x10, lsl 16 // puts 0x101002
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	open
	
	mov	x5, 0
	mov 	w4, w0
	mov	w3, 1
	mov	w2, 3
	mov	x1, 4096
	mov	x0, 0
	bl	mmap

	str	x0, [sp, 24]
	add	x0, x0, 4
	ldr	w1, [x0]

	ldr	x0, [sp, 24]
	add	x0, x0, 4
	and	w1, w1, -14680065 // ~(7<<21)
	str	w1, [x0]

	ldr	x0, [sp, 24]
	add	x0, x0, 4
	ldr	w1, [x0]

	ldr	x0, [sp, 24]
	add	x0, x0, 4
	orr	w1, w1, 2097152   // (1<<21)
	str	w1, [x0]

	ldr	x0, [sp, 24]
	add	x0, x0, 28 // offset to GPSET
	mov	w1, 131072 // (1<<17) aka (1<<pin)
	str	w1, [x0]

	mov	w0, 1
	bl	sleep

	ldr	x0, [sp, 24]
	add	x0, x0, 40 // offset to GPCLR
	mov	w1, 131072
	str	w1, [x0]

	mov	x1, 4096
	ldr	x0, [sp, 24]
	bl	munmap

	ldp	x29, x30, [sp], 48
	ret
