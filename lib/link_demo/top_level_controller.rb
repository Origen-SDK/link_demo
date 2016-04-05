module LinkDemo
  class TopLevelController
    include Origen::Controller
    include OrigenJTAG
    include OrigenARMDebug

    MDMAP_STAT = 0x01000000
    MDMAP_CTRL = 0x01000004

    # JTAG_CONFIG = {
    #  tclk_format:   :rh,
    #  tclk_multiple: 2
    # }

    # This is called automatically at the start of generating a pattern
    def startup(options = {})
      ss 'Reset the device and hold off core execution'
      tester.set_timeset('func_25mhz', 40)   # Where 40 is the period in ns
      pin(:resetb).drive!(0)
      arm_debug.abs_if.read_dp(:idcode, 0x4ba00477)      # Dummy read
      arm_debug.abs_if.write_dp(:ctrl_stat, 0x50000000)  # Power-up Debugger & System
      arm_debug.abs_if.read_dp(:ctrl_stat, 0xf0000000)   # Power-up Debugger & System (verify)
      arm_debug.abs_if.read_ap(MDMAP_STAT, 0x00000032)   # Wait for flash, system, and security to stabilize
      arm_debug.abs_if.write_ap(MDMAP_CTRL, 0x00000010)  # Assert debugger reset to CPU
      arm_debug.abs_if.read_ap(MDMAP_CTRL, 0x00000010)   # Assert debugger reset to CPU
      pin(:resetb).dont_care!
      arm_debug.abs_if.read_ap(MDMAP_STAT, 0x0000003a)   # Wait for flash, system, and security to stabilize
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
      arm_debug.write_register(reg, options)
    end

    def read_register(reg, options = {})
      arm_debug.read_register(reg, options)
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
