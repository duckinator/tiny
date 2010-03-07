if [ "clean" == "$1" ]; then
	rm -rf isofs tiny tiny.iso
	exit
fi

mkdir -p isofs

nasm -g -fbin -o isofs/tiny tiny.asm
genisoimage -r -b tiny -no-emul-boot -boot-load-size 4 -o tiny.iso isofs
