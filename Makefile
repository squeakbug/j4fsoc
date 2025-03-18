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
	@echo "Building Verilator simulator";
	+@$(SUBMAKE) sim/verilator
## }}}

.PHONY: doc
## {{{
doc:
	@echo "Building docs"; 
	cd doc;
	+@$(SUBMAKE) doc/
## }}}

.PHONY: formal
## {{{
formal:
	@echo "Running formal proofs";
	+@$(SUBMAKE) formal/
	+@$(SUBMAKE) formal/ report
## }}}

.PHONY: clean
## {{{
clean:
	+@$(SUBMAKE) --directory=rtl           clean
	+@$(SUBMAKE) --directory=sim/sv        clean
	+@$(SUBMAKE) --directory=sim/verilator clean
	+@$(SUBMAKE) --directory=bench/asm     clean
	+@$(SUBMAKE) --directory=bench/cpp     clean
	+@$(SUBMAKE) --directory=bench/formal  clean
## }}}