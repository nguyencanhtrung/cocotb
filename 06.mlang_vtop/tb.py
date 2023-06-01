import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def basic_count(dut):
    # generate a clock in cocotb
    cocotb.start_soon(Clock(dut.clk, 4, units="ns").start())

    # Reset DUT
    dut.rst.value = 1

    # reset the module, wait 2 rising edges until we release reset
    for _ in range(2):
        await RisingEdge(dut.clk)

    dut.rst.value = 0

    #run for 50ns checking count on each rising edge
    for cnt in range(200):
        await RisingEdge(dut.clk)
        v_count = dut.counter.value
        mod_cnt = cnt % 128
        assert v_count.integer == mod_cnt, "counter result is incorrect: %s != %s" % (
            str(dut.counter.value), mod_cnt)