# Makefile contributed by jtsiomb

src = granTrakTEC.asm

.PHONY: all
all: granTrakTEC.img granTrakTEC.com

granTrakTEC.img: $(src)
	nasm -f bin -o $@ $(src)

granTrakTEC.com: $(src)
	nasm -f bin -o $@ -Dcom_file=1 $(src)

.PHONY: clean
clean:
	$(RM) granTrakTEC.img granTrakTEC.com

.PHONY: rundosbox
rundosbox: granTrakTEC.com
	dosbox $<

.PHONY: runqemu
runqemu: granTrakTEC.img
	qemu-system-i386 -fda granTrakTEC.img