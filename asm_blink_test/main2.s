.arch armv8-a
.text
.global main

main:
    // Open /dev/gpiomem
    bl open_gpiomem
    cmp x0, #-1
    beq error_exit

    // mmap GPIO
    mov x0, x0 // file descriptor
    mov x1, #4096 // length
    mov x2, #PROT_READ | PROT_WRITE
    mov x3, #MAP_SHARED
    mov x4, #0 // offset
    mov x8, #222 // mmap syscall number
    svc 0


    cmp x0, #-1
    beq error_exit

    // Set GPIO 17 high
    ldr x1, =GPSET0_OFFSET
    add x1, x0, x1
    mov w2, #(1 << 17)
	b .
    str w2, [x1]

error_exit:
    mov x8, #1
    svc 0

open_gpiomem:
    ldr x0, =gpiomem_path
    mov x1, #O_RDWR
    ldr x2, =O_SYNC_value
    ldr x2, [x2]
    orr x1, x1, x2
    mov x8, #5
    svc 0
    ret

.data
gpiomem_path: .string "/dev/gpiomem"
O_SYNC_value: .dword 0x101000

.equ GPSET0_OFFSET, 0x1C
.equ PROT_READ, 0x1
.equ PROT_WRITE, 0x2
.equ MAP_SHARED, 0x01
.equ O_RDWR, 0x2
