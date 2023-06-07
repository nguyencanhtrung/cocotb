The repository includes introductory labs to help you get familiar to cocotb framework. 

* Lab 1: quickstart - traditional and cocotb sim flow with iverilog and gtkwave
* Lab 2: hello world - understanding about cocotb testbench
* Lab 3: datatypes - cocotb testbench datatypes
* Lab 4: questasim - cocotb sim flow with questasim mentor
* Lab 5: vhdl - vhdl module testing with cocotb (questasim mentor)
* Lab 6: mixed languages (mlang_vtop) - testing mixed language Verilog toplevel with cocotb (questasim mentor)
* Lab 7: mixed languages (mlang_vhdtop) - testing mixed language VHDL toplevel with cocotb (questasim mentor)
* Lab 8: mixed languages (mlang_extra) - testing mixed language system verilog and vhdl ()
* Lab 9: Xilinx IP cores included - simulating system which includes Xilinx IP Cores
* Lab 10:
* Lab 11:
* Lab 12:
* Lab 13:
* Lab 14:

---
## A. Installation

The current stable version of cocotb requires:

* Python 3.6+
* GNU Make 3+
* An HDL simulator (such as Icarus Verilog, Verilator, GHDL or other simulator)

### 1. Install Python 3.6+

Make sure you have python 3.6+ installed python --version or python3 --version

`sudo apt-get install make python3 python3-pip`

### 2. RTL simulator

Choose one of the following simulators.

#### a. Icarus verilog

Cocotb supports the following RTL simulators: Synopsys VCS, Intel Questa and Icarus Verilog. Icarus Verilog is free and can be obtained from [github](https://github.com/steveicarus/iverilog). To install Icarus Verilog, follow the instructions from the git repository, or simply:

`sudo apt install iverilog`

Another way to install iverilog is to recompile and install from source code by following steps. I recommend this way to get the lastest version.

```
git clone https://github.com/steveicarus/iverilog
cd iverilog
sh ./autoconf.sh
./configure
make
sudo make install
```

#### b. Questasim
If using Questasim, just need to add the Questasim installation path

`export MODELSIM_BIN_DIR=/opt/Siemens/Questa/20.4/questasim/bin`

Need to export the `LM_LICENSE_FILE` of Quartus package before running cocotb

Note that: You can use Intel Questasim or Mentor Questasim

### 3. Install gtkwave

`sudo apt install gtkwave`


### 4. Install cocotb

We can use the global python installation for cocotb. However, the better way is to create a separated environment for cocotb to prevent any corruption on main python installation.

Here, we create our own python env inside the cocotb working directory.

```
cd $PATH_TO_YOUR_COCOTB_WS
python3 -m venv venv
```

It creates the venv directory. Now, check the current environment

`which python3`

You will notice that it still uses the global environment usr/bin/python3

Lets activate the working environment

`source venv/bin/active`

Now, check the current environment

`which python3`

New environment for cocotb is activated.

#### Cocotb packages installation

`pip install cocotb pytest cocotb-bus cocotb-coverage`

Make sure pip version 3.x

`pip -V`

Otherwise, using pip3 instead.

The packages are installed in `venv/lib/python3.x/site-packages`

You may need to add to PATH and add this line into your .bashrc file

`export PATH=/home/tesla/.local/bin:$PATH`

Checking whether it is successfull or not by typing `cocotb-config --version`

You can run the cocotb installation process by

`source install_cocotb.sh`

---
## B. Tips and tricks

### 1. Mixed language simulation

#### a. Verilog or SV modules are not discovered automatically when toplevel is in VHDL and using Questasim or Modelsim

The following message shows the error

```
#    100.00ns INFO     cocotb.regression                  mixed_language_accessing_test failed
#                                                         Traceback (most recent call last):
#                                                           File "/home/tesla/workspace/05.Soc/02.cocotb/08.mlang_extra/tests/test_mixed_language.py", line 31, in mixed_language_accessing_test
#                                                             verilog.reset_n.value = 1
#                                                           File "/home/tesla/.local/lib/python3.8/site-packages/cocotb/handle.py", line 370, in __getattr__
#                                                             raise AttributeError(f"{self._name} contains no object named {name}")
#                                                         AttributeError: i_swapper_sv contains no object named reset_n
```

<strong>Workaround solution</strong>

In the python testbench, enabling `_discover_all()` for the Verilog or SV modules we want to access

```
verilog._discover_all()
```

where `verilog = dut.i_swapper_sv`

For more detail, open `08.mlang_extra/tests/test_mixed_language.py`

#### b. Fatal: (vsim-3693) The minimum time resolution limit (1ps) 

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

<strong>Solution </strong>

Adding vsim arguments specified in the `Makefile` variable `VSIM_ARGS` or `SIM_ARGS` of the Cocotb build system.

```
VSIM_ARGS=-t 1ps
```

or 

```
ifneq ($(filter $(SIM),questa modelsim),)
    SIM_ARGS += -t 1ps
endif
```

This way, one gets a consistent time resolution across VHDL and Verilog. The parameter has to be set for every project accordingly.

For more detail, open `07.mlang_vhdtop/Makefile`  or  `08.mlang_extra/tests/Makefile`

### 2. 