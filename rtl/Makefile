################################################################################
##
## Filename:	Makefile
## {{{
## Project: j4fsoc -- demo for starfighter project
##
## Purpose:	This makefile builds a verilator simulation.
##		It does not make the system within Vivado or Quartus.
##
################################################################################

CORE := core
PERIPH := peripheral

VOBJ := obj_dir
SUBMAKE := $(MAKE) --no-print-directory --directory=$(VOBJ) -f
ifeq ($(VERILATOR_ROOT),)
VERILATOR := verilator
else
VERILATOR := $(VERILATOR_ROOT)/bin/verilator
endif
##
# VCOVERAGE to get coverage analysis of our test cases
# VCOVERAGE := --coverage
VCOVERAGE :=
##
VFLAGS := -Wall -MMD --trace $(VCOVERAGE) -cc -y $(CORE) -y $(PERIPH)
VERILATE := $(VERILATOR) $(VFLAGS)

all: lint

.PHONY: lint
## {{{
lint:
	@verible-verilog-format --inplace rtl/**/*.sv rtl/*.sv
## }}}

.PHONY: top
top: $(VOBJ)/Vtop__ALL.a
$(VOBJ)/Vtop__ALL.a: $(VOBJ)/Vtop.cpp $(VOBJ)/Vtop.h
	$(SUBMAKE) Vtop.mk
$(VOBJ)/Vtop.cpp:
	$(VERILATE) --prefix Vtop -cc peripheral/top/top_top.sv

.PHONY: clean
## {{{
clean:
	rm -rf $(VOBJ)
## }}}
