org 7C00h

global Print				; allow everything to access Print
jmp Start				; skip the data

MTest:		db "This is a test string!  "
EMTest:
MTest2:		db "This is another test string!"
EMTest2:

Start:
	mov bx, 000Fh			; Page 0, color attribute 15 (white) for the int 10 calls below
	mov cx, 1			; We will write 1 char
	xor dx, dx			; Start at top-left corner
	mov ds, dx			; Ensure ds = 0 (to let us load the message)
	cld				; Ensure direction flag is cleared for LODSB

	push EMTest			; Push EMTest (end of MTest) onto the stack
	push MTest			; Push MTest onto the stack
	call Print			; Call `Print`
	add esp, 2

	push EMTest2			; Push EMTest2 (end of MTest2) onto the stack
	push MTest2			; Push MTest2 onto the stack
	call Print			; Call `Print`
	add esp, 2

	jmp Halt			; Halt system

Print:
	push ebp
	mov ebp, esp
	mov si, [ebp+6]			; Pops the beginning of the string into si
	mov di, [ebp+8]			; Pop end of string into eax

PrintChar:
	mov ah, 2			; PC BIOS Interrupt 10 Subfunction 2 - Set cursor position
					; AH = 2
					; BH = page, DH = row, DL = column
	int 10h
	lodsb				; Loads a byte of the message into AL.
					; DS is 0 and SI holds the offset of one of the bytes of the message

	mov ah, 9			; PC BIOS Interrupt 10 subfunction 9 - write character and color
					; AH = 9
					; BH = page, AL = character, BL = attribute, CX = character count
	int 10h

	inc dl				; Advance cursor

	cmp dl, 80			; Wrap around edge of screen if necessary (word-wrap)
	jne PrintChar.skip
	xor dl, dl			; Back to the first char of the line
	inc dh				; Next line!

	cmp dh, 25			; Wrap around bottom of the screen if necessary
	jne PrintChar.skip
	xor dh, dh

	.skip:
		cmp si, di		; If we're not at end of message
		jne PrintChar		; continue loading characters
		mov esp, ebp
		pop ebp
		ret

Halt:
	cli				; Stop interrupts
	hlt				; Halt system

times 0200h - 2 - ($ - $$) db 0		; Zerofill up to 510 bytes

dw 0AA55h				; Boot sector signature
