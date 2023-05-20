## Requirements

* Python 3.x
* Cocotb package
* Iverilator
* GTKwave


## 1. Traditional simulation with iverilog and gtkwave

### a. Notes

The following section in the implementation and testbench file

```
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, count_up);
end
```
to make it compatible with gtkwave


### b. Running testbench with iverilog 

`iverilog -o count_up_output count_up.v count_up_tb.v`

`vvp count_up_output`

The first command calls `iverilog`, which is a compiler that translates Verilog source code into executable programs for simulation. We then run `vvp` for simulation.


### c. Viewing results in gtkwave

Remember what we put in the implementation and testbench file

```
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, count_up);
end
```

`vvp` ran the simulation and dumped the signals to `dump.vcd`. This file can be opened in gtkwave.

`gtkwave *.vcd`

## 2. Cocotb simulation with iverilog and gtkwave

Now lets write a similar (but more rigorous) testbench in cocotb. Our verilog testbench didn’t do any checks on the output signal and wasn’t very flexible. Let’s fix that in our cocotb testbench. The below snippet creates a test, sets up a clock as a coroutine, toggles the reset signal and then runs a small assertion check over 50ns.

```
# Simple tests for an counter module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def basic_count(dut):
    # generate a clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    # Reset DUT
    dut.reset.value = 1

    # reset the module, wait 2 rising edges until we release reset
    for _ in range(2):
        await RisingEdge(dut.clk)
    dut.reset.value = 0

    # run for 50ns checking count on each rising edge
    for cnt in range(50):
        await RisingEdge(dut.clk)
        v_count = dut.count.value
        mod_cnt = cnt % 16
        assert v_count.integer == mod_cnt, "counter result is incorrect: %s != %s" % (str(dut.count.value), mod_cnt)
```

### a. Overview of the testbench.py file

Just like examples in the cocotb official documentation - testbench.py runs sequentially, from start to end. Each await expression suspends execution of the test until whatever event the test is waiting for occurs and the simulator returns control back to cocotb.

The gist of how cocotb works

* `dut.<signal name>.value` is how we read and write signals in our design in cocotb. We drive the reset signal via `dut.reset.value` and we read the output count via `dut.count.value`.

* `@cocotb.test()` is a python dectorator. This one marks a function as a test. You can have multiple tests in a single file.

* `cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())` is how we setup our clock to run as a separate coroutine. Don’t worry about the specifics of coroutines for now - just know we are driving the clock port via a separate coroutine baked into cocotb.

* `async def basic_count` its important to note that the test uses the `async` keyword. `async` functions can be scheduled to run concurrently and await for other things to happen (giving control back to other processes) before continuing.

* At the end of the testbench we have a simple assertion denoted with `assert`. This is similar to SystemVerilog assertions. This particular one just checks that the output is what we expect. If a failure occurs, it will report it back to us.

### b. Creating a cocotb Makefile

Cocotb requires a makefile to do things like: 
* Tell cocotb where you verilog files are
* Which simulator you are using
* What your cocotb testbench is called. 

After setting up your make file, running your testbench is as simple as typing `make`.

### c. Running cocotb testbench

Now type `make` wherever your makefile lives. After a short while your cocotb should run successfully.

This simple example showcases some inner working of cocotb and our sequential processing of the testbench.

In the above waveform we see the clock runs for 52 ns, when our test loop was set to run for 50 ns. Note the reset loop above our main testing loop which runs for 2 periods before our testbench even started!

The order of events was as follows:

* we setup a clock to run as a coroutine (basically launching a separate async function to run simultaneously to our test)
* we set the reset port to high and proceeded to the first loop
    * The `await` keyword halted our cocotb testbench, the simulator ran for a clock and then gave control back to the cocotb testbench where we once again awaited for the simulator to run for another period.
* Once it returned, our first loop (length 2) was over and we set the reset port to low
* we entered the second loop to run our actual test.

### Small change to understand cocotb coroutines
In the previous example the simulation ran for 52 ns. We ran the testbench sequentially from start to end. What if we had put the reset routine in its own function and started it as a coroutine? Let’s investigate. In `testbench2.py` we break out the reset routine into its own `async` function. In the `basic_count` test we then start the clock AND the reset routine as coroutines using `cocotb.start_soon`. We turned the assertions off for now, we only want to view an interesting aspect of the output waveform.

```
# Simple tests for an counter module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

async def run_reset_routine(dut):
    for _ in range(2):
        await RisingEdge(dut.clk)
    dut.reset.value = 0

@cocotb.test()
async def basic_count(dut):
    # generate a clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    # Reset DUT
    dut.reset.value = 1

    # reser the module, wait 2 rising edges until we release reset
    cocotb.start_soon(run_reset_routine(dut))


    # run for 50ns checking count on each rising edge
    for cnt in range(50):
        await RisingEdge(dut.clk)
        v_count = dut.count.value
        mod_cnt = cnt % 16
        #assert v_count.integer == mod_cnt, "counter result is incorrect: %s != %s" % (str(dut.count.value), mod_cnt)
```

Change the `Makefile` accordingly

```
# MODULE is the basename of the Python test file
MODULE = testbench2

```

If we view the output waveform in gtkwave, the entire test now only runs 50 ns! The `run_reset_routine` does, in fact, run concurrently with the `basic_test` function.