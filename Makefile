################################################################################
##
## Filename:	Makefile
## {{{
## Project:	j4fsoc -- demo for starfighter project
##
## Purpose:	This is a grand makefile for the entire project.  It will
##		build the assembler, and a SystemVerilog testbench, and then
##		even test the CPU via that test bench.
##
##	Targets include:
##
##		bench	Build the CPP test bench/debugger facility.
##
##		doc	Build the chip specification and the GPL
##			license.  These should be distributed pre-built, but
##			you are welcome to rebuild them if you would like.
##
##		rtl	Run Verilator on the RTL
##
##		test	Run the test bench on the assembler test file.
##
##
## Creator:	squeakbug
##
################################################################################

.PHONY: all

all: rtl sw sim

MAKE := make	# Was `which make`
SUBMAKE := $(MAKE) --no-print-directory -C

.PHONY: lint
## {{{
lint:
	@echo "Linting source code";
	+@$(SUBMAKE) rtl/
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