import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

in1       = [ 0x02, 0x05, 0x08, 0x0B, 0x0F ]
in2       = [ 0x03, 0x0A, 0x05, 0x06, 0x0F ]
products  = [ 0x06, 0x32, 0x28, 0x42, 0xE1 ]

@cocotb.test()
async def test_mult4x4(dut):
  clock = Clock(dut.clk, 50, units="ns")
  cocotb.start_soon(clock.start())

  dut._log.info("reset")
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 2)
  dut.rst_n.value = 1

  dut._log.info("start")
  dut.start.value = 0b0

  dut._log.info("check several mults")
  for i in range(5):
    dut.dataa.value = in1[i]
    dut.datab.value = in2[i]
    dut.start.value = 0b1
    await ClockCycles(dut.clk, 1)
    dut.start.value = 0b0
    await ClockCycles(dut.clk, 5)
    dut._log.info("product %s is %s", i, dut.product4x4_out.value)
    assert dut.product4x4_out.value == int(products[i])
