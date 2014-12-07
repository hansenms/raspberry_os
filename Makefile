CC=arm-none-eabi-gcc
CCFLAGS=-mcpu=arm1176jzf-s -fpic -ffreestanding

all: kernel.img

boot.o: boot.s
	arm-none-eabi-gcc -mcpu=arm1176jzf-s -fpic -ffreestanding -c boot.s -o boot.o

timer.o: timer.s
	arm-none-eabi-gcc -mcpu=arm1176jzf-s -fpic -ffreestanding -c timer.s -o timer.o

gpio.o: gpio.s
	arm-none-eabi-gcc -mcpu=arm1176jzf-s -fpic -ffreestanding -c gpio.s -o gpio.o

kernel.o: kernel.c
	arm-none-eabi-gcc -mcpu=arm1176jzf-s -fpic -ffreestanding -std=gnu99 -c kernel.c -o kernel.o -O2 -Wall -Wextra

myos.elf: boot.o kernel.o timer.o gpio.o linker.ld
	arm-none-eabi-gcc -T linker.ld -o myos.elf -ffreestanding -O2 -nostdlib boot.o kernel.o timer.o gpio.o

kernel.img: myos.elf
	arm-none-eabi-objcopy myos.elf -O binary kernel.img

clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.elf
	rm -f *.img
	rm -f *~
