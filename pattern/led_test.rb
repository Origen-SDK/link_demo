Pattern.create do
  # Write to CCOB reg, could be any writable reg
  dut.arm_debug.write_register(0x0000_0010, address: 0x4002_0004)
  dut.arm_debug.read_register(0x0000_0010, address: 0x4002_0004)
  dut.arm_debug.write_register(0xDEAD_BEEF, address: 0x2000_0000)
  dut.arm_debug.read_register(0xDEAD_BEEF, address: 0x2000_0000)
  dut.arm_debug.write_register(0xFFFF_FFFF, address: 0x4004_8038) #Clock gating
  dut.arm_debug.write_register(0x0000_0100, address: 0x4004_C010) #Pin muxing
  dut.arm_debug.write_register(0x0000_0010, address: 0x400F_F0D4) #Data direction
  dut.arm_debug.write_register(0x0000_0000, address: 0x400F_F0C0) #Data output
  dut.arm_debug.write_register(0x0000_0010, address: 0x400F_F0C0)
  dut.arm_debug.write_register(0x0000_0000, address: 0x400F_F0C0)
  dut.arm_debug.write_register(0x0000_0010, address: 0x400F_F0C0)
  dut.arm_debug.write_register(0x0000_0000, address: 0x400F_F0C0)
  dut.arm_debug.write_register(0x0000_0010, address: 0x400F_F0C0)
  dut.arm_debug.write_register(0x0000_0000, address: 0x400F_F0C0)
  dut.arm_debug.write_register(0x0000_0010, address: 0x400F_F0C0)
end
