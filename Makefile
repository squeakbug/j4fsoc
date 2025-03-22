.PHONY: all

all: lint rtl sim

MAKE := make
SUBMAKE := $(MAKE) --no-print-directory -C

.PHONY: lint
## {{{
lint:
	@echo "Linting source code";
	@verible-verilog-format --inplace rtl/**/*.sv rtl/*.sv
## }}}

.PHONY: rtl
## {{{
rtl:
	@echo "Building rtl for Verilator";
	+@$(SUBMAKE) rtl/
## }}}

.PHONY: sim
sim: rtl
## {{{
	@echo "Building Verilator simulation";
	+@$(SUBMAKE) sim/verilator
## }}}

.PHONY: sim
sim: rtl
## {{{
	@echo "Building Icarus simulation";
	+@$(SUBMAKE) sim/sv
## }}}

.PHONY: clean
## {{{
clean:
	+@$(MAKE) --directory=rtl           clean
	+@$(MAKE) --directory=sim/sv        clean
	+@$(MAKE) --directory=sim/verilator clean
## }}}
