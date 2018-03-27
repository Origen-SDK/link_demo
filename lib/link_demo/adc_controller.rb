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

      ss 'Enable the ADC clock' # this should really be an API call to the top-level
      dut.scgc6.write!(0x4800_0001)

      ss 'Setup the ADC to do 16 averages in hardware'
      sc3.avge.write(0x1) # enable hardware averaging
      sc3.avgs.write(0x2) # take 16 averages
      sc3.avgs.write(0x3) # take 32 averages
      sc3.write!

      ss 'Setup the configuration register'
      cfg1.adlpc.write(0x0) # Power Mode
      cfg1.adiv.write(opts[:adc_clock_div]) # Internal ADC Clock Div
      cfg1.adlsmp.write(opts[:long_samples]) # Sample Time (Short Samples = 0, Long Samples = 1)
      cfg1.mode.write(0x3) # Use single-ended, 16-bit conversions
      cfg1.adiclk.write(0x0) # ADC Input Clock Source
      cfg1.write!

      ss "Perform an ADC measurement on channel #{opts[:channel]} without differential mode"
      sc1.aien.write(0x0) # Ensure conversion-complete interrupt is off
      sc1.diff.write(opts[:diff]) # Write differential mode bit. 0 = Single-ended. 1 = Differential
      sc1.adch.write(opts[:channel]) # Select channel (default channel 24 for sense bus)
      sc1.write!

      # Wait for the conversion. Either 128 clocks per number of conversions or whatever was passed in via
      # the options.
      tester.cycle(repeat: opts[:conversion_time])

      ss 'Check that the conversion has completed'
      sc1.coco.read!(0x1) # Check for COnversion COmplete (COCO)

      # Return the register bits containing the result to the caller.
      # Digital measurement, convert using standard D/A conversion,
      # Vref ~= 3.3 V for default reference
      r.d
    end
  end
end
