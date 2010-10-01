require 'betabrite'
require 'usb'
require 'timeout'

Rails.logger.debug "Initializing Betabrite..."

# Override usb_interface method to make more compatible with OS X
module BetaBrite
  class USB < Base
    private
    def usb_interface(device)
      handle = device.usb_open
      raise "Unable to obtain a handle to the device." if handle.nil?

      retries = 0
      begin
        error_code = handle.usb_claim_interface(INTERFACE)
        raise unless error_code.nil?
      rescue
        raise "Unable to claim the device interface. Try unplugging and replugging the USB cable."
      end

      handle
    end
  end
end


bb = BetaBrite::USB.new do |sign|
  sign.allocate do |memory|
    # Reserved for ContinuousIntegration
    memory.text('A', 4096)
    
    # These strings hold project status messages, one per.
    # Add more if you have more builds to monitor, and be sure to also add them to the textfile definition below.
    memory.string('a', 128)
    memory.string('b', 128)
    memory.string('c', 128)
    memory.string('d', 128)
    memory.string('e', 128)
    memory.string('f', 128)
    memory.string('g', 128)
    memory.string('h', 128)
    memory.string('i', 128)
    memory.string('j', 128)

    # These strings are reserved for ad hoc message
    memory.string('1', 128)
    memory.string('2', 128)
    memory.string('3', 128)
    memory.string('4', 128)
  end
end
Timeout.timeout(10) { bb.write_memory! }

bb = BetaBrite::USB.new do |sign|
  #sign.stringfile('a') do
  #  print string("RADIATOR").color_mix
  #end
  
  sign.textfile do
    print stringfile("1")
    print stringfile("2")
    print stringfile("a")
    print stringfile("b")
    print stringfile("c")
    print stringfile("d")
    print stringfile("e")
    print stringfile("f")
    print stringfile("g")
    print stringfile("h")
    print stringfile("i")
    print stringfile("j")
    print stringfile("3")
    print stringfile("4")
  end
end
Timeout.timeout(10) { bb.write! }

Rails.logger.debug "Initialization complete."