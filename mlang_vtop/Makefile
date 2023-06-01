SIM ?= questa

# Enable GUI - for QuestaSim only
GUI = 0

# TOPLEVEL_LANG ?= vhdl
TOPLEVEL_LANG ?= verilog


# TOPLEVEL is the name of the toplevel module in your VHDL file
TOPLEVEL = counter_wrapper

# VHDL source
VHDL_SOURCES = counter.vhd
VERILOG_SOURCES = counter_wrapper.v

# Module is the basename of the Python test file
MODULE = tb

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	@rm -rf __pycache__ vsim.wlf modelsim.ini results.xml transcript sim_build
