Pattern.create do
  # Write to CCOB reg, could be any writable reg
  mem(0x4002_0004).write!(0x0000_0010)
  mem(0x4002_0004).read!(0x0000_0010) 
  mem(0x2000_0000).write!(0xDEAD_BEEF) 
  mem(0x2000_0000).read!(0xDEAD_BEEF) 
  mem(0x4004_8038).write!(0xFFFF_FFFF)  #Clock gating
  mem(0x4004_C010).write!(0x0000_0100)  #Pin muxing
  mem(0x400F_F0D4).write!(0x0000_0010)  #Data direction
  mem(0x400F_F0C0).write!(0x0000_0000)  #Data output
  mem(0x400F_F0C0).write!(0x0000_0010) 
  mem(0x400F_F0C0).write!(0x0000_0000) 
  mem(0x400F_F0C0).write!(0x0000_0010) 
  mem(0x400F_F0C0).write!(0x0000_0000) 
  mem(0x400F_F0C0).write!(0x0000_0010) 
  mem(0x400F_F0C0).write!(0x0000_0000) 
  mem(0x400F_F0C0).write!(0x0000_0010) 
end
