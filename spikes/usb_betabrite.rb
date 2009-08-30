require 'usb'

class UsbBetabrite
  # USB Device Codes
  PRODUCT_ID     = 0x1234
  VENDOR_ID      = 0x8765
  INTERFACE      = 0x00
  RECV_LENGTH    = 0x40 # Max Packet Size of 64
  SEND_LENGTH    = 0x40 # Max Packet Size of 64
  WRITE_ENDPOINT = 0x02 
  READ_ENDPOINT  = 0x82
  WRITE_TIMEOUT  = 5000
  READ_TIMEOUT   = 5000

  # Creates a new interface between ruby and the Betabrite
  def initialize
    @device = get_usb_device()
    @handle = get_usb_interface(@device)
  end

  def write(bytes)
    # write twice to force past the 'data toggle bit' check
    @handle.usb_interrupt_write(WRITE_ENDPOINT, bytes.pack('C*'), WRITE_TIMEOUT)
    @handle.usb_interrupt_write(WRITE_ENDPOINT, bytes.pack('C*'), WRITE_TIMEOUT)
  end
  
  private
  
  def get_usb_device
    device = USB.devices.find {|d| d.idProduct == PRODUCT_ID and d.idVendor == VENDOR_ID }
    raise "Unable to locate the BETABrite." if device.nil?
    return device
  end
  
  def get_usb_interface(device)
    handle = device.open
    raise "Unable to obtain a handle to the device." if handle.nil?

    retries = 0
    begin
      error_code = handle.usb_claim_interface(INTERFACE)
      raise unless error_code.nil?
    rescue
      handle.usb_detach_kernel_driver_np(INTERFACE);
      if retries.zero? 
        retries += 1
        retry
      else
        raise "Unable to claim the device interface."
      end
    end
    
    raise "Unable to set alternative interface." unless handle.set_altinterface(0).nil?

    handle
  end
end

betabrite = UsbBetabrite.new

# Write a Text File
bytes = [ 0x00, 0x00, 0x00, 0x00, 0x00 ] # Autobaud
bytes << 0x01 # Start of Header
bytes << 0x5A # All sign types, "Z"
bytes << 0x30 << 0x30 # "00" so all signs listen
bytes << 0x02 # Start of text
bytes << 0x41 # Write text file
bytes << 0x41 # File Label "A"
bytes << 0x1B # ESC
bytes << 0x20 # Display Middle
bytes << 0x61 # Rotate
bytes << 0x1C # Specify Color
bytes << 0x42 # Color Mix
"IT'S ALIVE!!!".unpack('C*').each { |b| bytes << b }
# bytes << 0x03 # End of Text - chokes USB Betabrite, expects checksum after this
bytes << 0x04 # End of Transmission

betabrite.write bytes

# Allocate Memory for a String File
# bytes = [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 ]
# bytes << 0x5A # All sign types, "Z"
# bytes << 0x30 << 0x30 # "00" so all signs listen
# bytes << 0x02 # Start of text
# bytes << 0x45 # Write Special Functions
# bytes << 0x24 # Set Memory Configuration
# bytes << 0x41 # File label of the Text File which will call this String File
# bytes << 0x41 # Text File Type
# bytes << 0x55 # Text File is Unlocked ("U")
# "0400".unpack('C*').each {|b| bytes << b} # Text File size in hex ("0400" = 1024D)
# bytes << 0x46 << 0x46 # Text File's start time, FF is always
# bytes << 0x30 << 0x30 # Stop time, 00 is just padding
# bytes << 0x31 # File label of the String File
# bytes << 0x32 # String File type
# bytes << 0x55 # String File is Unlocked ("U")
# # bytes << 0x4C # String File is Locked ("L")
# "0020".unpack('C*').each {|b| bytes << b} # String File size in hex ("0020" = 32D)
# "0000".unpack('C*').each {|b| bytes << b} # padding
# bytes << 0x04 # End of Transmission
# 
# sp.write bytes


# Write a Text File
# bytes = [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 ]
# bytes << 0x5A # All sign types, "Z"
# bytes << 0x30 << 0x30 # "00" so all signs listen
# bytes << 0x02 # Start of text
# bytes << 0x41 # Write text file
# bytes << 0x41 # File Label "A"
# bytes << 0x1B # ESC
# bytes << 0x20 # Display Middle
# bytes << 0x61 # Rotate
# "XX ".unpack('C*').each { |b| bytes << b } # Any static text
# bytes << 0x10 # Insert String File
# bytes << 0x31 # String File Label
# " XX".unpack('C*').each { |b| bytes << b } # Any static text
# # bytes << 0x03 # End of Text
# bytes << 0x04 # End of Transmission
# 
# sp.write bytes


# 10.times do |i|
#   sleep 3
# 
#   # Write to the String File
#   bytes = [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 ]
#   bytes << 0x5A # All sign types, "Z"
#   bytes << 0x30 << 0x30 # "00" so all signs listen
#   bytes << 0x02 # Start of text
#   bytes << 0x47 # String File type
#   bytes << 0x31 # String File label
#   "IT WORKS #{i}".unpack('C*').each { |b| bytes << b } # Any dynamic text
#   bytes << 0x04 # End of Transmission
# 
#   sp.write bytes
# end
