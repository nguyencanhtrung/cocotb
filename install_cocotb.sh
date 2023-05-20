#!/bin/bash

CWD=$(pwd)
python3 -m venv $CWD/venv
source $CWD/venv/bin/activate

pip install cocotb pytest cocotb-bus cocotb-coverage
export PATH=~/.local/bin:$PATH

cocotb-config