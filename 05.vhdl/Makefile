SIM ?= questa

# Enable GUI - for QuestaSim only
GUI = 0

TOPLEVEL_LANG ?= vhdl

# TOPLEVLE is the name of the toplevel module in your VHDL file
TOPLEVEL = counter

# VHDL source
VHDL_SOURCES = counter.vhd

# Module is the basename of the Python test file
MODULE = tb

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
