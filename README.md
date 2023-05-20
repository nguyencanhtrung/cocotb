The repository includes introductory labs to help you get familiar to cocotb framework. 

* Lab 1: quickstart - traditional and cocotb sim flow with iverilog and gtkwave
* Lab 2: hello world - understanding about cocotb testbench
* Lab 3: datatypes - cocotb testbench datatypes
* Lab 4: questasim - cocotb sim flow with questasim

## Installation

The current stable version of cocotb requires:

* Python 3.6+
* GNU Make 3+
* An HDL simulator (such as Icarus Verilog, Verilator, GHDL or other simulator)

### Install icarus verilog simulator for simulating verilog

`sudo apt install iverilog`

### Install gtkwave

`sudo apt install gtkwave`

### Install Python 3.6+

Make sure you have python 3.6+ installed python --version or python3 --version

`sudo apt-get install make python3 python3-pip`

### Install cocotb

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

Checking whether it is successfull or not by typing `cocotb-config`

You can run the cocotb installation process by

`source install_cocotb.sh`


Starting from

Quickstart > Hello World 