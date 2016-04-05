module LinkDemo
  class FlashController
    include Origen::Controller

    def program(data, options = {})
      set_ccob(0, 0x06)
      set_address(options[:address])
      fccob1.write(data)
      launch
      tester.wait time_in_us: 100
      cc 'Verify the command completed without errors'
      fstat[7..0].assert!(0x80)
    end

    def erase(options = {})
      set_ccob(0, 0x09)
      set_address(options[:address])
      launch
      tester.wait time_in_ms: 10
      cc 'Verify the command completed without errors'
      fstat[7..0].assert!(0x80)
    end

    private

    def launch
      fccob0.write!
      fccob1.write!
      fccob2.write!
      fstat.ccif.write!(1)
    end

    def set_address(address)
      unless address
        fail 'No address supplied!'
      end
      unless address >= 0x20_000 && address <= 0x20_3FF
        fail 'For the purposes of this demo, please limit flash operations to the memory range 0x2_0000 to 0x2_03FF'
      end
      set_ccob(1, address[23..16])
      set_ccob(2, address[15..8])
      set_ccob(3, address[7..0])
    end

    # Deal with the fact that the block guide is decribed in 8-bit terms but the
    # register access is 32-bit
    def set_ccob(i, val)
      case i
      when 0
        fccob0[31..24].write(val)
      when 1
        fccob0[23..16].write(val)
      when 2
        fccob0[15..8].write(val)
      when 3
        fccob0[7..0].write(val)
      when 4
        fccob1[31..24].write(val)
      when 5
        fccob1[23..16].write(val)
      when 6
        fccob1[15..8].write(val)
      when 7
        fccob1[7..0].write(val)
      when 8
        fccob2[31..24].write(val)
      when 9
        fccob2[23..16].write(val)
      when 10
        fccob2[15..8].write(val)
      when 11
        fccob2[7..0].write(val)
      else
        fail "Illegal CCOB index: #{i}"
      end
    end
  end
end
