SIM ?= questa
GUI ?= 1

# GPI_EXTRA=vpi

VSIM_ARGS=-t 1ps

TOPLEVEL_LANG ?= vhdl
TOPLEVEL = counter_wrapper

VERILOG_SOURCES = counter.v
VHDL_SOURCES = counter_wrapper.vhd

MODULE = tb

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	@rm -rf __pycache__ vsim.wlf modelsim.ini results.xml transcript sim_build