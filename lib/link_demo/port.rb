module LinkDemo
  class Port
    include Origen::Model

    attr_reader :size

    def initialize(options = {})
      # Defines the default option values
      options = {
        size: 32
      }.merge(options)
      @size = options[:size]
      instantiate_registers
    end

    def instantiate_registers
      size.times do |i|
        # Port control register
        reg "pcr#{i}".to_sym, i * 4 do |reg|
          reg.bit 24, :isf, access: :w1c
          reg.bits 19..16, :irqc
          reg.bit 15, :lk
          reg.bits 10..8, :mux
          reg.bit 6, :dse
          reg.bit 5, :ode
          reg.bit 4, :pfe
          reg.bit 2, :sre
          reg.bit 1, :pe
          reg.bit 0, :ps
        end
      end
    end
  end
end
