module LinkDemo
  class Flash
    include Origen::Model

    def initialize(options = {})
      instantiate_registers
    end

    def instantiate_registers
      reg :fstat, 0 do |reg|
        reg.bits 31..24, :fopt, reset: :memory, access: :ro
        reg.bits 23..22, :keyen, reset: :memory, access: :ro
        reg.bits 21..20, :meen, reset: :memory, access: :ro
        reg.bits 19..18, :fslacc, reset: :memory, access: :ro
        reg.bits 17..16, :sec, reset: :memory, access: :ro
        reg.bit 15, :ccie
        reg.bit 14, :rdcollie
        reg.bit 13, :ersareq
        reg.bit 12, :erssusp
        reg.bit 7, :ccif, access: :w1c
        reg.bit 6, :rdcolerr, access: :w1c
        reg.bit 5, :accerr, access: :w1c
        reg.bit 4, :fpviol, access: :w1c
        reg.bit 0, :mgstat0, access: :ro
      end

      add_reg :fccob0, 4
      add_reg :fccob1, 8
      add_reg :fccob2, 0xC
    end
  end
end
