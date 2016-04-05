Pattern.create do
  dut.flash.program(0x1111_1111, address: 0x2_0000)
end
