PREFIX := riscv64-unknown-elf

build: counter.objdump

counter.objdump: counter.elf
	$(PREFIX)-objdump -D $< > $@
counter.elf: counter.asm
	$(PREFIX)-gcc -T kernel.ld -o $@ -march=rv32i -mabi=ilp32 -mcmodel=medany \
	    -nostartfiles $<
%.memfile: %
	@if grep -q 'elf32' $*.objdump; then \
		BIT_WIDTH=32; \
	else \
		BIT_WIDTH=64; \
	fi; \
	echo "Processing $< with --bit-width $$BIT_WIDTH"; \
	$(PREFIX)-elf2hex --bit-width $$BIT_WIDTH --input $< --output $@

#########################################################
# simulation in Icarus verilog

TOPMODULE=sm_testbench
IVARG = -g2005
IVARG += -D ICARUS
IVARG += -I ../
IVARG += -I ../../../src
IVARG += -I ../../../testbench
IVARG += -s $(TOPMODULE)
IVARG += ../../../src/*.v
IVARG += ../../../testbench/*.v

# make icarus - run compilation using Icarus Verilog simulator
#    rm -rf sim; mkdir sim; - recreate simulation folder
#    cp *.hex sim/          - copy memory image (program.hex) inside it
#    cd sim && iverilog     - go to simulation folder and start Icarus Verilog compiler
#                             it will produced the compiled simulation script sim/a.out
#      -g2005                 - Verilog Specification version
#      -D ICARUS              - define ICARUS verilog macro (the same as `define)
#      -I ../                 - path to search for `include files
#      -s sm_testbench        - use sm_testbench as top level module
#      ../../../src/*.v       - complie all the verilog sources from ../../../src/ folder
#    cd sim && vvp          - go to simulation folder and start Icarus Verilog runtime engine
#      -n                     - makes $stop a synonym for $finish
#      -la.lst                - write log to file a.lst
#      a.out                  - run a.out simulation
icarus_sim: program.hex
	rm -rf sim
	mkdir sim
	cp *.hex sim
	cd sim && iverilog $(IVARG)
	cd sim && vvp -n -la.lst a.out 

# make gtkwave - open Icarus Verilog simulation dump using gtkwave
gtkwave:
	cd sim && gtkwave dump.vcd

#########################################################

.PHONY: clean
clean:
	rm -rf sim
	rm -f *.elf *.dis *.mem *.hex
