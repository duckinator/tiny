org 7C00h

mov ah, 0xe

mov si, string
print:
	lodsb
	cmp al, 0
	jz $
	int 0x10
	jmp print

string  db  "Hello, world!", 0
