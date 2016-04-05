module LinkDemo
  class GPIO
    include Origen::Model

    def initialize(options = {})
      instantiate_registers(options)
    end

    def instantiate_registers(options = {})
      # Data output register
      add_reg :pdor, 0
      # Data input register
      add_reg :pdir, 0x10
      # Data direction register
      add_reg :pddr, 0x14
    end
  end
end
