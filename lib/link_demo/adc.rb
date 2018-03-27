module LinkDemo
  class ADC
    include Origen::Model
    include CrossOrigen

    def initialize
      cr_import(path: "#{Origen.root}/ipxact/adc_regs.xml")
    end
  end
end
