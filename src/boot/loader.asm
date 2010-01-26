bits 16
org 7C00h

section .text

jmp Start				; skip the data

print:
	mov ah, 0xe
	mov bh, 0
	.type:
		lodsb
		or al, al
		jz .done
		int 0x10
		jmp .type
	.done:
		ret

TestString   db "This is a test string!  ",13,10,0
TestString2  db "This is another test string!",13,10,0

Start:
	cli
	
	mov ax, 0x0
	mov ds, ax

	mov si, TestString
	call print

	mov si, TestString2
	call print

	jmp Halt			; Halt system

Halt:
	cli				; Stop interrupts
	hlt				; Halt system

times 0200h - 2 - ($ - $$) db 0		; Zerofill up to 510 bytes

dw 0AA55h				; Boot sector signature
