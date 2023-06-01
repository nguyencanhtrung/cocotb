## Mixed language simulation with cocotb and Questa

There are 2 cases of mixed languages design

* Toplevel is verilog wrapping VHDL modules
* Toplevel is vhdl wrapping Verilog modules 

In this case, we are going to explore the second case having a vhdl toplevel wrapping a verilog module.


### Prerequisites for mixed languages simulation

* RTL simulator supports mixed language - I uses Questasim from Mentor

### Simulation

* Toplevel: `counter_wrapper.vhd`
* Internal module: `counter.v`

The content of `Makefile`

```
SIM ?= questa
GUI ?= 0

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
```

You can see we have one more line `VSIM_ARGS=-1 1ps`. Without this line we get an error as the following:

```
# ** Fatal: (vsim-3693) The minimum time resolution limit (1ps) in the Verilog source is smaller than the one chosen for SystemC or VHDL units in the design. Use the vsim -t option to specify the desired resolution.
# FATAL ERROR while loading design
# Error loading design
```

The issue is the default time resolution of the VHDL simulator is used as specified in the modelsim.ini

```
[vsim]
; vopt flow
; Set to turn on automatic optimization of a design.
; Default is on
VoptFlow = 1

; Simulator resolution
; Set to fs, ps, ns, us, ms, or sec with optional prefix of 1, 10, or 100.
Resolution = ns
```

And it is `ns` which does not match with the default resolution of verilog module (normally `1ps`). 

Then, the solution is to make same resolution across VHDL and Verilog. 

Additional vsim arguments can be specified by the Makefile variable VSIM_ARGS of the Cocotb build system.

```
VSIM_ARGS=-t 1ps
```

This way, one gets a consistent time resolution across VHDL and Verilog. The parameter has to be set for every project accordingly.