module LinkDemo
  class ADCController
    include Origen::Controller

    def initialize
      @options = {
        channel:         0x0,
        settling_time:   500,
        conversion_time: 1024 * (16 + 1),
        diff:            0,
        long_samples:    0,
        adc_clock_div:   0x3
      }.merge(options)
    end

    def measure_voltage(options = {})
      # Merge any default options or options passed in during initialization with whatever options are passed in
      # for this specific measure_voltage operation
      opts = @options.merge(options)

      # Ensure some settling time. Default value from initialization or whatever was passed into the options.
      tester.cycle(repeat: opts[:settling_time])

      # Enable the ADC clock
      $dut.reg(:scgc6).write!(0x4800_0001)

      # Setup the ADC to do 16 averages in hardware
      reg(:sc3).bits(:avge).write(0x1) # enable hardware averaging
      reg(:sc3).bits(:avgs).write(0x2) # take 16 averages
      reg(:sc3).bits(:avgs).write(0x3) # take 32 averages
      reg(:sc3).write!

      # Setup the configuration register
      reg(:cfg1).bits(:adlpc).write(0x0) # Power Mode
      reg(:cfg1).bits(:adiv).write(opts[:adc_clock_div]) # Internal ADC Clock Div
      reg(:cfg1).bits(:adlsmp).write(opts[:long_samples]) # Sample Time (Short Samples = 0, Long Samples = 1)
      reg(:cfg1).bits(:mode).write(0x3) # Use single-ended, 16-bit conversions
      reg(:cfg1).bits(:adiclk).write(0x0) # ADC Input Clock Source
      reg(:cfg1).write!

      # Setup the ADC to perform an ADC measurement on the selected channel without differential mode.
      reg(:sc1).bits(:aien).write(0x0) # Ensure conversion-complete interrupt is off
      reg(:sc1).bits(:diff).write(opts[:diff]) # Write differential mode bit. 0 = Single-ended. 1 = Differential
      reg(:sc1).bits(:adch).write(opts[:channel]) # Select channel (default channel 24 for sense bus)
      reg(:sc1).write!

      # Wait for the conversion. Either 128 clocks per number of conversions or whatever was passed in via
      # the options.
      $tester.cycle(repeat: opts[:conversion_time])

      # Check that the conversion has completed. The measurements are working but this line still show failures...
      # Not sure why, need to look into this. Possibly an error with the block being updated and the RGen register
      # model doesn't know about it.
      reg(:sc1).bits(:coco).read!(0x1) # Check for COnversion COmplete (COCO)

      # Return the register containing the result. Digital measurement, convert using standard D/A conversion,
      # Vref ~= 3.3 V for default reference
      reg(:r)
  end
  end
end
