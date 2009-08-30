require 'usb'
%w{ ../vendor/betabrite/lib }.each do |path|
  $LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), path)))
end
require 'betabrite'

bb = BetaBrite::USB.new do |sign|
  sign.allocate do |memory|
    memory.text('A', 4096)
    # memory.string('a', 64)
    memory.string('b', 512)
  end
end
bb.write_memory!

bb = BetaBrite::USB.new do |sign|
  sign.textfile do
    # print string("Displaying ")
    # print stringfile("a")
    # print string(" bytes: ")
    print stringfile("b")
  end
end
bb.write!

600.times do |count|
  
  # bb = BetaBrite::USB.new do |sign|
  #   sign.stringfile('a') do
  #     print string("#{count}")
  #   end
  # end
  # bb.write!

  message = ""
  (0..count).each { message += "A" }
  bb = BetaBrite::USB.new do |sign|
    sign.stringfile('b') do
      print string(message.size.to_s)
      print string(message)
    end
  end
  bb.write!

  sleep 1
end
