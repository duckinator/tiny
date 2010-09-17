org 7C00h

mov ah, 0xe

mov si, string
print:
	lodsb
	int 0x10
	or al, al
	jne print

string  db  "Hello, world!", 0
