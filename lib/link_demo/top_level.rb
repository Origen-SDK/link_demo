module LinkDemo
  class TopLevel
    include Origen::TopLevel
    include CrossOrigen

    def initialize(options = {})
      instantiate_pins(options)
      instantiate_sub_blocks(options)
      instantiate_registers(options)
    end

    def instantiate_pins(options = {})
      add_pin :tclk
      add_pin :tdi
      add_pin :tdo
      add_pin :tms
      add_pin :resetb
      pin_pattern_order :tclk, :tms, :tdi, :tdo, :resetb
      if tester.link?
        # TODO: pin_pattern_order should be enough
        tester.pinorder = 'tclk,tms,tdi,tdo,resetb'
      end
    end

    def instantiate_sub_blocks(options = {})
      sub_block :arm_debug, class_name: 'OrigenARMDebug::Driver', aps: { mem_ap: 0x00000000, mdmap: 0x01000000 }

      sub_block :flash, class_name: 'Flash', base_address: 0x4002_0000
      sub_block :adc, class_name: 'ADC', base_address: 0x4003_B000

      sub_block :portb, class_name: 'Port', base_address: 0x4004_A000
      sub_block :portc, class_name: 'Port', base_address: 0x4004_B000
      sub_block :portd, class_name: 'Port', base_address: 0x4004_C000

      sub_block :gpiob, class_name: 'GPIO', base_address: 0x400F_F040
      sub_block :gpioc, class_name: 'GPIO', base_address: 0x400F_F080
      sub_block :gpiod, class_name: 'GPIO', base_address: 0x400F_F0C0
    end

    # Any top-level registers should be defined here
    def instantiate_registers(options = {})
      add_reg :scgc6, 0x4004_803C
    end
  end
end
