
all: kernel.img

boot.o: boot.S
	arm-none-eabi-gcc -mcpu=arm1176jzf-s -fpic -ffreestanding -c boot.S -o boot.o

kernel.o: kernel.c
	arm-none-eabi-gcc -mcpu=arm1176jzf-s -fpic -ffreestanding -std=gnu99 -c kernel.c -o kernel.o -O2 -Wall -Wextra

myos.elf: boot.o kernel.o linker.ld
	arm-none-eabi-gcc -T linker.ld -o myos.elf -ffreestanding -O2 -nostdlib boot.o kernel.o

kernel.img: myos.elf
	arm-none-eabi-objcopy myos.elf -O binary kernel.img

clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.elf
	rm -f *.img
	rm -f *~
