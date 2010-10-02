# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
# The VERY MINIMUM needed to get ruby-usb set up with bundler.
#require 'usb/version'
 
Gem::Specification.new do |s|
  s.name        = "ruby-usb"
  s.version     = "1.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["FOO"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""
 
  s.required_rubygems_version = ">= 1.0.0"
  s.rubyforge_project         = "ruby-usb"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(COPYING README Changelog)
  s.require_path = 'lib'
end
