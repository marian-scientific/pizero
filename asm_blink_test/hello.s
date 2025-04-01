.section .data

msg:
.ascii "hi\n"

.section .text

.global main
.global _start

_start:
main:
	mov x0,#1
	adr x1,msg
	mov x2,#3
	mov x8,#64
	svc #0

	mov x0,#0
	mov x8,#93
	svc #0

