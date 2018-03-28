$tester = OrigenLink::VectorBased.new('192.168.7.2', 12777)

$tester.pinformat = "func_25mhz,tclk,rh"
$tester.pintiming = "func_25mhz,tdi,0,tms,0,tdo,1,resetb,0"
