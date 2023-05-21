SIM ?= icarus
TOPLEVEL_LANG ?= verilog
PWD=$(shell pwd)
VERILOG_SOURCES = $(PWD)/or_gate.v
TOPLEVEL = or_gate
MODULE = tb
or:
	$(MAKE) sim
include $(shell cocotb-config --makefiles)/Makefile.sim