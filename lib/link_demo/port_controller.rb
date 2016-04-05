module LinkDemo
  class PortController
    # Enable the GPIO function on the given pin indexes
    #
    # @example
    #   dut.portd.enable_gpio(1,5)
    def enable_gpio(*pin_indexes)
      pin_indexes.each do |i|
        send("pcr#{i}").mux.write!(0b001)
      end
    end
  end
end
