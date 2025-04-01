.arch armv8-a
.text
.global main
.global _start
_start:
main:
	ldr x0,=0xFE200000
	ldr x1,=17
	ldr w2,=1
	lsl w2, w2, w1
	ldr w3,[x0,#4]
	bic w3, w3, #(7<<21)
	orr w3, w3, #(1<<21)

loop:
	ldr x0,=0xFE200000
	ldr x1,=17
	ldr w2,=1
	lsl w2, w2, w1
	str w2,[x0,#40]

	ldr x0,#1000000
	bl delay_us	

	ldr x0,=0xFE200000
	ldr x1,=17
	ldr w2,=1
	lsl w2, w2, w1
	str w2,[x0,#34]

	ldr x0,#1000000
	bl delay_us	

	b loop

.global delay_us

delay_us:
	ldr x1,=0xFE003004
	ldr x2,[x1]
	add x2, x2, x0
delay_loop:
	ldr x3,[x1]
	cmp x3,x2
	b.lo delay_loop
	ret



.end

