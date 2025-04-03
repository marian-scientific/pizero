	.arch armv8-a
	.file	"main.c"
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"/dev/gpiomem"
	.align	3
.LC1:
	.string	"Can't open /dev/gpiomem"
	.align	3
.LC2:
	.string	"Error: %s\n"
	.align	3
.LC3:
	.string	"mmap error"
	.align	3
.LC4:
	.string	"mmap error: %s\n"
	.align	3
.LC5:
	.string	"GPFSEL1: 0x%X\n"
	.align	3
.LC6:
	.string	"GPSET0: 0x%X\n"
	.align	3
.LC7:
	.string	"GPCLR0: 0x%X\n"
	.align	3
.LC8:
	.string	"munmap error"
	.align	3
.LC9:
	.string	"munmap error: %s\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	mov	w1, 4098
	movk	w1, 0x10, lsl 16 // puts 0x101002
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	open

	str	w0, [sp, 44] //fd
	ldr	w0, [sp, 44]
	cmp	w0, 0
	bge	.L2
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	perror

	bl	__errno_location

	ldr	w0, [x0]
	bl	strerror

	mov	x1, x0
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf

	mov	w0, 1
	b	.L3
.L2:
	mov	x5, 0
	ldr	w4, [sp, 44]
	mov	w3, 1
	mov	w2, 3
	mov	x1, 4096
	mov	x0, 0
	bl	mmap

	str	x0, [sp, 32]
	ldr	x0, [sp, 32]
	cmn	x0, #1
	bne	.L4
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	perror

	bl	__errno_location

	ldr	w0, [x0]
	bl	strerror

	mov	x1, x0
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf

	ldr	w0, [sp, 44]
	bl	close

	mov	w0, 1
	b	.L3
.L4:
	ldr	x0, [sp, 32]
	str	x0, [sp, 24]
	ldr	x0, [sp, 24]
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
	add	x0, x0, 4
	ldr	w0, [x0]
	mov	w1, w0
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf

	ldr	x0, [sp, 24]
	add	x0, x0, 28 // offset to GPSET
	mov	w1, 131072 // (1<<17) aka (1<<pin)
	str	w1, [x0]

	ldr	x0, [sp, 24]
	add	x0, x0, 28
	ldr	w0, [x0]
	mov	w1, w0
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf

	mov	w0, 1
	bl	sleep

	ldr	x0, [sp, 24]
	add	x0, x0, 40 // offset to GPCLR
	mov	w1, 131072
	str	w1, [x0]

	ldr	x0, [sp, 24]
	add	x0, x0, 40
	ldr	w0, [x0]
	mov	w1, w0
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf

	mov	x1, 4096
	ldr	x0, [sp, 32]
	bl	munmap

	cmp	w0, 0
	bge	.L5
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	perror

	bl	__errno_location
	ldr	w0, [x0]
	bl	strerror

	mov	x1, x0
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
.L5:
	ldr	w0, [sp, 44]
	bl	close
	mov	w0, 0
.L3:
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
