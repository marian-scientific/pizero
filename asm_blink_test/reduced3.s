.global _start

.section .data
gpiomem_path: .string "/dev/gpiomem"

.section .text
_start:
    // Open /dev/gpiomem
    mov x0, #-100    // dirfd = AT_FDCWD (current directory)
    ldr x1, =gpiomem_path // pathname
    mov w2, #2       // flags = O_RDWR
    mov w3, #0            // mode (not used)
    mov w8, #56   // syscall number
    svc #0                // Invoke syscall


	mov	x5, 0
	mov 	w4, w0
	mov	w3, 1
	mov	w2, 3
	mov	x1, 4096
	mov	x0, 0
	mov 	x8, 222
	svc 	#0

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


    // Successful exit
    mov x0, #0
    mov w8, #93
    svc #0

