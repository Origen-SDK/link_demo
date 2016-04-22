Pattern.create do
  # This is not an example of how to write a good pattern in Origen!!!!
  # Just to show that for messing around you can easily bit bang memory locations, here
  # to toggle a port to flash an LED.
  dut.mem(0x4002_0004).write!(0x0000_0010)
  dut.mem(0x4002_0004).read!(0x0000_0010) 
  dut.mem(0x4004_8038).write!(0xFFFF_FFFF)  #Clock gating
  dut.mem(0x4004_C010).write!(0x0000_0100)  #Pin muxing
  dut.mem(0x400F_F0D4).write!(0x0000_0010)  #Data direction
  10.times do
    dut.mem(0x400F_F0C0).write!(0x0000_0000)  #Data output
    tester.wait(time_in_s: 0.5)
    dut.mem(0x400F_F0C0).write!(0x0000_0010)
    tester.wait(time_in_s: 0.5)
  end
end
