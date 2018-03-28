module LinkDemo
  class TopLevelController
    include Origen::Controller

    # JTAG_CONFIG = {
    #  tclk_format:   :rh,
    #  tclk_multiple: 2
    # }

    # This is called automatically at the start of generating a pattern
    def startup(options = {})
      tester.set_timeset(:func_25mhz, 40)   # Where 40 is the period in ns

      ss 'Reset the device and hold off core execution'
      pin(:resetb).drive!(0)
      arm_debug.jtag_dp.idcode.read!(0x4ba00477)      # Dummy read
      arm_debug.jtag_dp.ctrl_stat.write!(0x50000000)  # Power-up Debugger & System
      arm_debug.jtag_dp.ctrl_stat.write!(0xf0000000)   # Power-up Debugger & System (verify)
      arm_debug.mdmap.read_register(0x00000032, address: 0)   # Wait for flash, system, and security to stabilize
      arm_debug.mdmap.write_register(0x00000010, address: 0x4)  # Assert debugger reset to CPU
      arm_debug.mdmap.read_register(0x00000010, address: 0x4)  # Assert debugger reset to CPU
      pin(:resetb).dont_care!
      arm_debug.mdmap.read_register(0x0000003A, address: 0)   # Wait for flash, system, and security to stabilize
      dut.mem(0x4004_8038).write!(0xFFFF_FFFF)           # Turn off all clock gating
    end

    # This is called automatically at the end of generating a pattern
    def shutdown(options = {})
      ss 'Put the device into reset'
      pin(:resetb).drive!(0)
    end

    # This is called automatically at the start of an interactive session (origen i)
    def interactive_startup
      startup if tester.link?
    end

    # This is called automatically at the end of an interactive session (origen i)
    def interactive_shutdown
      if tester.link?
        shutdown
        # TODO: This should be automated
        tester.synchronize
      end
    end

    def write_register(reg, options = {})
      arm_debug.mem_ap.write_register(reg, options)
    end

    def read_register(reg, options = {})
      arm_debug.mem_ap.read_register(reg, options)
    end

    def read_portb_3_0(value)
      ss 'Enable PortB[3:0] as inputs'
      portb.enable_gpio(0, 1, 2, 3)
      gpiob.pddr[3..0].write!(0x0)
      ss 'Read value from PortB[3:0]'
      gpiob.pdir[3..0].read!(value)
    end
  end
end
