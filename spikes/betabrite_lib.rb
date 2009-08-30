require 'usb'
%w{ ../vendor/betabrite/lib }.each do |path|
  $LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), path)))
end
require 'betabrite'

bb = BetaBrite::USB.new do |sign|
  sign.allocate do |memory|
    memory.text('A', 4096)
    memory.string('a', 64)
    memory.string('b', 64)
  end
end
bb.write_memory!

bb = BetaBrite::USB.new do |sign|
  sign.textfile do
    print string("Counting down: ").green
    print stringfile("a")
    print stringfile("b")
  end
end
bb.write!

(0..10).each do |i|
  bb = BetaBrite::USB.new do |sign|
    sign.stringfile('a') do
      print string("#{10 - i} ").red
    end
  end
  bb.write!
  sleep 2
end

bb = BetaBrite::USB.new do |sign|
  sign.stringfile('b') do
    print string("BLAST OFF!").red
  end
end
bb.write!

