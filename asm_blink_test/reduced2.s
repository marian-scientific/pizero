.global _start

.equ SYS_open, 56
#6

.section .data
gpiomem_path: .string "/dev/gpiomem"

.section .bss
.comm errno, 4

.section .text
_start:

  ldr x1, =gpiomem_path
  movz x1, #0x1010  // Move the upper 16 bits (shifted left)
  movk x1, #0x0002, lsl #0 // Move the lower 16 bits
  mov w2, #0
  mov w8, #SYS_open
  svc #0

  ldr x0, =gpiomem_path
  movz x1, #0x1010  // Move the upper 16 bits (shifted left)
  movk x1, #0x0002, lsl #0 // Move the lower 16 bits
  mov w2, #0
  mov w8, #SYS_open
  svc #0


  cmp x0, #0
  blt open_error


  // Exit
  mov x0, #0
  mov w8, #93
  svc #0

open_error:
  ldr x1, =errno
  ldr w1, [x1]
  // w1 now contains the errno value
  // ... handle errno error ...
  mov x0, #1
  mov w8, #93
  svc #0
	
	mov	x5, 0
	mov 	w4, w0
	mov	w3, 1
	mov	w2, 3
	mov	x1, 4096
	mov	x0, 0
	bl	mmap

	
	str	x0, [sp, 24]
	add	x0, x0, 4
	b _exit
	ldr	w1, [x0] 
# segfault

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

_exit:
	mov	x0, 0
	mov	x8, 93
	svc	0

