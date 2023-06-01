## Mixed language simulation with cocotb and Questa

There are 2 cases of mixed languages design

* Toplevel is verilog wrapping VHDL modules
* Toplevel is vhdl wrapping Verilog modules 

In this case, we are going to explore the first case having a verilog toplevel wrapping a vhdl module.


### Prerequisites for mixed languages simulation

* RTL simulator supports mixed language - I uses Questasim from Mentor

### Simulation

* Toplevel: `counter_wrapper.v`
* Internal module: `counter.vhd`

Simply just need to adjust the `Makefile` to include all sources with `VHDL_SOURCES` for VHDL implementation and `VERILOG_SOURCES` for verilog implementation as the following

```
SIM ?= questa

# Enable GUI - for QuestaSim only
GUI = 0

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
```

When typing `make` the framework will call 

* `vcom` to compile your `VHDL_SOURCES` 
* `vlog` to compile your `VERILOG_SOURCES`

Note that: it is recommend to `make clean` before rerun `make` to ensure the consistency.

## Cocotb's Makefile glimpse

Your `Makefile` just includes cocotb's make rules

`include $(shell cocotb-config --makefiles)/Makefile.sim`

To find the cocotb's rule location just type

`cocotb-config --makefile`

It will show you somthing like this

```
<PATH_TO_PYTHON_VENV>/lib/python3.8/site-packages/cocotb/share/makefiles/
```

Go to this location and open `Makefile.sim` to see how does Cocotb's make rules work

```
# This file includes an appropriate makefile depending on the SIM variable.

.PHONY: all
all: sim

# NOTE: keep this at 80 chars.
define help_targets =
Targets
=======
sim                       Unconditionally re-run the simulator (default)
regression                Run simulator when dependencies have changes
clean                     Remove build and simulation artefacts
help                      This help text

endef

# NOTE: keep this at 80 chars.
define help_makevars =
Variables
=========

The following variables are makefile variables:

Makefile-based Test Scripts
---------------------------
GUI                       Set this to 1 to enable the GUI mode in the simulator
SIM                       Selects which simulator Makefile to use
WAVES                     Enable wave traces dump for Riviera-PRO and Questa
VERILOG_SOURCES           A list of the Verilog source files to include
VHDL_SOURCES              A list of the VHDL source files to include
VHDL_SOURCES_<lib>        VHDL source files to include in *lib* (GHDL/ModelSim/Questa/Xcelium only)
VHDL_LIB_ORDER            Compilation order of VHDL libraries (needed for ModelSim/Questa/Xcelium)
SIM_CMD_PREFIX            Prefix for simulation command invocations
COMPILE_ARGS              Arguments to pass to compile stage of simulation
SIM_ARGS                  Arguments to pass to execution of compiled simulation
EXTRA_ARGS                Arguments for compile and execute phases
PLUSARGS                  Plusargs to pass to the simulator
COCOTB_HDL_TIMEUNIT       Default time unit for simulation
COCOTB_HDL_TIMEPRECISION  Default time precision for simulation
CUSTOM_COMPILE_DEPS       Add additional dependencies to the compilation target
CUSTOM_SIM_DEPS           Add additional dependencies to the simulation target
SIM_BUILD                 Define a scratch directory for use by the simulator
SCRIPT_FILE               Simulator script to run (for e.g. wave traces)

endef


# NOTE: keep *two* empty lines between "define" and "endef":
define newline


endef

# this cannot be a regular target because of the way Makefile.$(SIM) is included
ifeq ($(MAKECMDGOALS),help)
    $(info $(help_targets))
    $(info $(help_makevars))
    # hack to get newlines in output, see https://stackoverflow.com/a/54539610
    # NOTE: the output of the command must not include a '%' sign, otherwise the formatting will break
    help_envvars := $(subst %,${newline},$(shell cocotb-config --help-vars | tr \\n %))
    $(info ${help_envvars})
    # is there a cleaner way to exit here?
    $(error Stopping after printing help)
endif

# Default to Icarus if no simulator is defined
SIM ?= icarus

# Maintain backwards compatibility by supporting upper and lower case SIM variable
SIM_LOWERCASE := $(shell echo $(SIM) | tr A-Z a-z)

# Directory containing the cocotb Makfiles (realpath for Windows compatibility)
COCOTB_MAKEFILES_DIR := $(realpath $(shell cocotb-config --makefiles))

include $(COCOTB_MAKEFILES_DIR)/Makefile.deprecations

HAVE_SIMULATOR = $(shell if [ -f $(COCOTB_MAKEFILES_DIR)/simulators/Makefile.$(SIM_LOWERCASE) ]; then echo 1; else echo 0; fi;)
AVAILABLE_SIMULATORS = $(patsubst .%,%,$(suffix $(wildcard $(COCOTB_MAKEFILES_DIR)/simulators/Makefile.*)))

ifeq ($(HAVE_SIMULATOR),0)
    $(error Couldn't find makefile for simulator: "$(SIM_LOWERCASE)"! Available simulators: $(AVAILABLE_SIMULATORS))
endif

include $(COCOTB_MAKEFILES_DIR)/simulators/Makefile.$(SIM_LOWERCASE)

```

Most of lines are for `make help` command 

```
ifeq ($(MAKECMDGOALS),help)
    $(info $(help_targets))
    $(info $(help_makevars))
    # hack to get newlines in output, see https://stackoverflow.com/a/54539610
    # NOTE: the output of the command must not include a '%' sign, otherwise the formatting will break
    help_envvars := $(subst %,${newline},$(shell cocotb-config --help-vars | tr \\n %))
    $(info ${help_envvars})
    # is there a cleaner way to exit here?
    $(error Stopping after printing help)
endif
```

now lets look at these lines

```
# Default to Icarus if no simulator is defined
SIM ?= icarus

# Maintain backwards compatibility by supporting upper and lower case SIM variable
SIM_LOWERCASE := $(shell echo $(SIM) | tr A-Z a-z)

# Directory containing the cocotb Makfiles (realpath for Windows compatibility)
COCOTB_MAKEFILES_DIR := $(realpath $(shell cocotb-config --makefiles))

include $(COCOTB_MAKEFILES_DIR)/Makefile.deprecations

HAVE_SIMULATOR = $(shell if [ -f $(COCOTB_MAKEFILES_DIR)/simulators/Makefile.$(SIM_LOWERCASE) ]; then echo 1; else echo 0; fi;)
AVAILABLE_SIMULATORS = $(patsubst .%,%,$(suffix $(wildcard $(COCOTB_MAKEFILES_DIR)/simulators/Makefile.*)))

ifeq ($(HAVE_SIMULATOR),0)
    $(error Couldn't find makefile for simulator: "$(SIM_LOWERCASE)"! Available simulators: $(AVAILABLE_SIMULATORS))
endif

include $(COCOTB_MAKEFILES_DIR)/simulators/Makefile.$(SIM_LOWERCASE)
```

it simply calls the predefined Makefiles in the `./simulators/`. There are several supported simulators

```
.
├── Makefile.deprecations
├── Makefile.inc
├── Makefile.sim
└── simulators
    ├── Makefile.activehdl
    ├── Makefile.cvc
    ├── Makefile.ghdl
    ├── Makefile.icarus
    ├── Makefile.ius
    ├── Makefile.modelsim
    ├── Makefile.questa
    ├── Makefile.riviera
    ├── Makefile.vcs
    ├── Makefile.verilator
    └── Makefile.xcelium
```

It is not recommend but you can directly change the Makefile.* here to fit your need.

