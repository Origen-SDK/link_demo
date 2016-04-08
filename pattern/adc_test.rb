Pattern.create do
  # Write to CCOB reg, could be any writable reg
  dut.arm_debug.write_register(0x0000_0010, address: 0x4002_0004)
  dut.arm_debug.read_register(0x0000_0010, address: 0x4002_0004)
  dut.arm_debug.write_register(0xDEAD_BEEF, address: 0x2000_0000)
  dut.arm_debug.read_register(0xDEAD_BEEF, address: 0x2000_0000)
  $dut.adc.measure_voltage
  debugger
end
