import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_dut(dut):
    cocotb.start_soon(Clock(dut.clk, 4, units="ns").start())

    dut.rst.value = 1

    for _ in range (3):
        await RisingEdge(dut.clk)
    
    dut.rst.value = 0


    for cnt in range(20):
        await RisingEdge(dut.clk)
        v_count = dut.count.value
        mod_cnt = cnt % 128
        assert v_count.integer == mod_cnt, "counter result is incorrect: %s != %s" % (
            str(dut.count.value), mod_cnt)