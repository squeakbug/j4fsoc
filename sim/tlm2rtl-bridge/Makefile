CXXFLAGS := -Wall -faligned-new -Og -g -D__WORDSIZE=64
RTLD	 := ../../rtl
RTLOBJD  := $(RTLD)/obj_dir
OBJDIR   := obj-pc

ifneq ($(VERILATOR_ROOT),)
VERILATOR:=$(VERILATOR_ROOT)/bin/verilator
else
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | tail -1 | sed -e " s/^.*=\s*//"')
endif
export	$(VERILATOR)
VROOT   := $(VERILATOR_ROOT)
VINCS	:= -I$(VROOT)/include -I$(VROOT)/include/vltstd
INCS	:= -I$(RTLOBJD) -I$(RTLD) $(VINCS)
VLSRCS	:= verilated.cpp verilated_vcd_c.cpp verilated_threads.cpp
#
# Use the verilated_cov.cpp source when you want to run Verilator coverage
# (The CPU is covered better by the formal proofs ...)
# VLSRCS	:= verilated.cpp verilated_vcd_c.cpp verilated_cov.cpp
VLOBJS := $(addprefix $(OBJDIR)/,$(subst .cpp,.o,$(VLSRCS)))
VLIB   := $(addprefix $(VROOT)/include/,$(VLSRCS))

.PHONY: top
top: $(VOBJ)/Vtop__ALL.a
$(VOBJ)/Vtop__ALL.a: $(VOBJ)/Vtop.cpp $(VOBJ)/Vtop.h
	$(SUBMAKE) Vtop.mk
$(VOBJ)/Vtop.cpp:
	$(VERILATOR) --prefix Vtop -cc $(VERILATOR_INPUT) --top-module top

all: top_tb

$(OBJDIR)/%.o: %.cpp
	$(mk-objdir)
	$(CXX) $(CFLAGS) $(INCS) -c $< -o $@

top_tb: $(OBJDIR)/top_tb.o $(RTLOBJD)/Vtop__ALL.a
	$(CXX) $(CFLAGS) $(VDEFS) $(INCS) $^ $(VLIB) -lpthread -o $@

tags: $(VLIB) $(SOURCES)
	@ctags $(SOURCES) $(VLIB)

.PHONY: depends
depends: $(OBJDIR)/
	$(build-depends)

define	mk-objdir
	@bash -c "if [ ! -e $(OBJDIR) ]; then mkdir -p $(OBJDIR)/; fi"
endef

.PHONY: clean
clean:
	rm -rf $(OBJDIR)/
	rm -rf div_tb
	rm -rf pfcache_tb
