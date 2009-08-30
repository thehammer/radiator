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

  def self.display(message)
    begin
      Timeout.timeout(5) do
        handle = get_usb_interface
        write handle, text_command_for(message)
      end
    rescue StandardError, Timeout::Error => e
      puts "Error connecting to Betabrite, #{e}"
    ensure
      release_usb_interface handle unless handle.nil?
    end
  end

  private
  
  def self.write(handle, command)
    # write twice to force past the 'data toggle bit' check
    handle.usb_interrupt_write(WRITE_ENDPOINT, command.pack('C*'), WRITE_TIMEOUT)
    handle.usb_interrupt_write(WRITE_ENDPOINT, command.pack('C*'), WRITE_TIMEOUT)
  end
  
  def self.text_command_for(message)
    # Write a Text File
    command = [ 0x00, 0x00, 0x00, 0x00, 0x00 ] # Autobaud
    command << 0x01 # Start of Header
    command << 0x5A # All sign types, "Z"
    command << 0x30 << 0x30 # "00" so all signs listen
    command << 0x02 # Start of text
    command << 0x41 # Write text file
    command << 0x41 # File Label "A"
    command << 0x1B # ESC
    command << 0x20 # Display Middle
    command << 0x61 # Rotate
    command << 0x1C # Specify Color
    command << 0x42 # Color Mix
    message.unpack('C*').each { |b| command << b }
    # command << 0x03 # End of Text - chokes USB Betabrite, expects checksum after this
    command << 0x04 # End of Transmission
    
    command
  end
  
  def self.get_usb_device
    device = USB.devices.find {|d| d.idProduct == PRODUCT_ID and d.idVendor == VENDOR_ID }
    raise "Unable to locate the BETABrite." if device.nil?
    return device
  end
  
  def self.get_usb_interface(device = nil)
    device ||= get_usb_device
    handle = device.open
    raise "Unable to obtain a handle to the device." if handle.nil?

    retries = 0
    begin
      error_code = handle.usb_claim_interface(INTERFACE)
      raise unless error_code.nil?
    rescue
      # handle.usb_detach_kernel_driver_np(INTERFACE);
      if retries.zero? 
        retries += 1
        retry
      else
        raise "Unable to claim the device interface."
      end
    end
    
    # raise "Unable to set alternative interface." unless handle.set_altinterface(0).nil?

    handle
  end
  
  def self.release_usb_interface(handle)
    handle.usb_close
  end
end
