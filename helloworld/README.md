### Running the example

```
tesla@tesla:~/workspace/05.Soc/10.studies/02.cocotb/helloworld$ make
rm -f results.xml
make -f Makefile results.xml
make[1]: Entering directory '/home/tesla/workspace/05.Soc/10.studies/02.cocotb/helloworld'
rm -f results.xml
MODULE=testbench TESTCASE= TOPLEVEL=hello TOPLEVEL_LANG=verilog \
         /usr/local/bin/vvp -M /home/tesla/.local/lib/python3.8/site-packages/cocotb/libs -m libcocotbvpi_icarus   sim_build/sim.vvp 
     -.--ns INFO     gpi                                ..mbed/gpi_embed.cpp:76   in set_program_name_in_venv        Did not detect Python virtual environment. Using system-wide Python interpreter
     -.--ns INFO     gpi                                ../gpi/GpiCommon.cpp:101  in gpi_print_registered_impl       VPI registered
     0.00ns INFO     cocotb                             Running on Icarus Verilog version 13.0 (devel)
     0.00ns INFO     cocotb                             Running tests with cocotb v1.7.1 from /home/tesla/.local/lib/python3.8/site-packages/cocotb
     0.00ns INFO     cocotb                             Seeding Python random module with 1684403145
     0.00ns INFO     cocotb.regression                  Found test testbench.hello_world
     0.00ns INFO     cocotb.regression                  running hello_world (1/1)
hello learncocotb.com
     0.00ns INFO     cocotb.regression                  hello_world passed
     0.00ns INFO     cocotb.regression                  **************************************************************************************
                                                        ** TEST                          STATUS  SIM TIME (ns)  REAL TIME (s)  RATIO (ns/s) **
                                                        **************************************************************************************
                                                        ** testbench.hello_world          PASS           0.00           0.00          7.21  **
                                                        **************************************************************************************
                                                        ** TESTS=1 PASS=1 FAIL=0 SKIP=0                  0.00           0.12          0.01  **
                                                        **************************************************************************************
                                                        
make[1]: Leaving directory '/home/tesla/workspace/05.Soc/10.studies/02.cocotb/helloworld'
```

### What Just Happened?

How did we go from `make` to suddenly running icarus and then cocotb? The sequence of events was as follows:

* `make` compiles and executes the HDL (`iverilog` and `vvp` are ran during the make sequence)
* the simulator connects to cocotb during the make process
* the simulator advances time and cocotb schedules things to occur, values to be set, etc.
* Test completes

The output of `make` shows that our test, `hello_world`, ran to completion and reported a pass (because nothing was checked in our testbench). The `"hello learncocotb.com"` string was also displayed on the output.

For ease of viewing we can also redirect the output of `vvp` to a logfile.

### Adding logfile

We can redirect the stdout of `vvp` using the `-l` switch for adding a logfile. If we take a look at [Makefile.icarus](https://github.com/cocotb/cocotb/blob/master/cocotb/share/makefiles/simulators/Makefile.icarus) - a makefile ran when we run our top level make - we can see that there are environment variables that can be added to the `vvp` execution:

`$(SIM_CMD_PREFIX) $(ICARUS_BIN_DIR)/vvp -M $(shell cocotb-config --lib-dir) -m $(shell cocotb-config --lib-name vpi icarus) $(SIM_ARGS) $(EXTRA_ARGS) $(SIM_BUILD)/sim.vvp $(PLUSARGS)`


We can add our logfile to either `SIM_ARGS` or `EXTRA_ARGS`. Let’s add a logfile to our top level make via `SIM_ARGS`. `SIM_ARGS` can either be defined in our makefile or added at the command line at runtime. For now we will add it to the command line.

`make SIM_ARGS=-lhello_stdout`

When the above command is executed the stdout from the simulation will be redirected to a file called `hello_stdout` which will be created next to your `testbench.py` is. That file will now contain our `$display` string.

A list of all `make` build options and environment variables available to users are outlined in the [cocotb docs](https://docs.cocotb.org/en/stable/building.html)