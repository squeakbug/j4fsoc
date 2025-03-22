ASM_FILES := $(wildcard *.asm)

VMEM_TARGETS := $(patsubst %.asm,%_data.vmem,$(ASM_FILES)) $(patsubst %.asm,%_text.vmem,$(ASM_FILES))

all: $(VMEM_TARGETS)

%.o: %.asm
	clang -mno-relax --target=riscv32 -march=rv32im -c -o $@ $^
%_text.vmem: %.elf
	llvm-objcopy -j .text -O binary $< $@
%_data.vmem: %.elf
	llvm-objcopy -j .data -O binary $< $@
%.elf: %.o
	ld.lld -T kernel.ld -o $@ $<

.PHONY: clean
clean:
	rm -f *.elf *.dis *.mem *.hex *.o *.bin *.vmem
	rm -f $(VMEM_TARGETS)
