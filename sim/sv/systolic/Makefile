# If $VERILATOR_ROOT isn't in the environment, we assume it is part of a
# package install, and verilator is in your path. Otherwise find the
# binary relative to $VERILATOR_ROOT (such as when inside the git sources).
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
VERILATOR_COVERAGE = verilator_coverage
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
VERILATOR_COVERAGE = $(VERILATOR_ROOT)/bin/verilator_coverage
endif

VERILATOR_FLAGS = +1800-2023ext+
# Generate C++ in executable form
VERILATOR_FLAGS += -cc --exe
# Generate makefile dependencies (not shown as complicates the Makefile)
#VERILATOR_FLAGS += -MMD
# Optimize
VERILATOR_FLAGS += --x-assign 0
# Warn abount lint issues; may not want this on less solid designs
VERILATOR_FLAGS += -Wall
# Make waveforms
VERILATOR_FLAGS += --trace
# Check SystemVerilog assertions
VERILATOR_FLAGS += --assert
# Generate coverage analysis
VERILATOR_FLAGS += --coverage
# Run Verilator in debug mode
# VERILATOR_FLAGS += --debug
# Add this trace to get a backtrace in gdb
#VERILATOR_FLAGS += --gdbbt
# Handle `wait` statements
VERILATOR_FLAGS += --timing
# Set top module
VERILATOR_FLAGS += --top-module testbench

# OR lint
VERILATOR_FLAGS += --lint-only
# Enable output from preprocessor
# VERILATOR_FLAGS += --E
# Should produce binary file
# VERILATOR_FLAGS += --binary
# OR build
# VERILATOR_FLAGS += --binary --build -j

SOURCES = \
	../../../rtl/wishbone/wb_intf.sv \
	../../../rtl/systolic/systolic_config_pkg.sv \
	../../../rtl/systolic/systolic_array.sv \
	../../../rtl/systolic/systolic_pe.sv \
	../../../rtl/systolic/wb_systolic_array.sv \
	../../../rtl/generic/mem/ram1p1rwbe.sv \
	../../../rtl/generic/flop/flopen.sv \
	../wishbone/wb_pkg.sv \
	../wishbone/wb_packet_base.sv \
	../wishbone/wb_cfg_base.sv \
	../wishbone/wb_checker_base.sv \
	../wishbone/wb_master_gen_base.sv \
	../wishbone/wb_monitor_base.sv \
	../wishbone/wb_master_driver_base.sv \
	../wishbone/wb_master_agent_base.sv \
	../wishbone/wb_env_base.sv \
	./systolic_pkg.sv \
	./systolic_wb_driver.sv \
	./systolic_cfg_base.sv \
	./systolic_checker_base.sv \
	./systolic_env_base.sv \
	./systolic_test_base.sv \
	./systolic_wb_gen.sv \
	./testbench.sv

INCLUDE_DIRS = \
	-I../../../rtl/wishbone \
	-I../wishbone \
	-I../../../rtl/systolic \

all: lint compile run view

lint:
	$(VERILATOR) $(VERILATOR_FLAGS) --lint-only -Wall $(INCLUDE_DIRS) $(SOURCES)

compile:
	$(VERILATOR) $(VERILATOR_FLAGS) $(INCLUDE_DIRS) $(SOURCES)

run:
	./obj_dir/Vtestbench

view:
	gtkwave wave.vcd

clean:
	rm -rf obj_dir wave.vcd
