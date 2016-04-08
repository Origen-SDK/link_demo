module LinkDemo
  class ADC
    include Origen::Model
    include CrossOrigen
    # Returns the object that instantiated the ADC
    # top-level SoC object

    def initialize
      cr_import(path: "#{Origen.root}/ipxact/adc.xml")
    end
  end
end
