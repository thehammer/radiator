# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
# The VERY MINIMUM needed to get ruby-usb set up with bundler.
#require 'usb/version'
 
Gem::Specification.new do |s|
  s.name        = "betabrite"
  s.version     = "1.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["FOO"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""
 
  s.required_rubygems_version = ">= 1.0.0"
  s.rubyforge_project         = "betabrite"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(README.txt EXAMPLES History.txt)
  s.require_path = 'lib'
end
