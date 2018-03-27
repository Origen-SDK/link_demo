Pattern.create do
  ss "Write to RAM"
  dut.mem(0x2000_0000).write!(0xDEAD_BEEF)
  ss "Read from RAM"
  dut.mem(0x2000_0000).read!(0xDEAD_BEEF)
end
