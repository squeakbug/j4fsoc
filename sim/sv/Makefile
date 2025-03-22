all: gtkwave

SUBMAKE := $(MAKE) --no-print-directory -C

TOPMODULE = j4fsoc_tb
IVARG = -g2012
IVARG += -D ICARUS
IVARG += -I ../../
IVARG += -I ../../../rtl
IVARG += -s $(TOPMODULE)
IVARG += $(wildcard ../../../rtl/*.sv)
IVARG += ../../../rtl/**/*.sv

dump.vcd:
	rm -rf sim
	mkdir sim
	+@$(SUBMAKE) ../firmware
	cp ../firmware/*.vmem sim
	cd sim && iverilog $(IVARG)
	cd sim && vvp -n -la.lst a.out 

gtkwave: dump.vcd
	gtkwave dump.vcd
