The lab is same as lab 1: quickstart. We use it as a guide to show how to use Cocotb with Questa Simulator. Note that: using Questa sim requires a license, you can run Cocotb with either Intel Questasim or Mentor Questasim version.

## Requirements

* Python 3.x
* Cocotb package
* Questasim

## Setup Questasim environment

If using Questasim, just need to add the Questasim installation path

`export MODELSIM_BIN_DIR=/opt/Siemens/Questa/20.4/questasim/bin`

Need to export the `LM_LICENSE_FILE` of Quartus package before running cocotb

Note that: You can use Intel Questasim or Mentor Questasim

## How to run simulation

Setup the Python virtual environment

```
source ./cocotb_env.sh
cd ./questa
```

Running cocotb simulation with Questa Simulator

`make`

or

`make SIM=questa`

Simulation with GUI

`make GUI=1`
