# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Radiator::Application.load_tasks

begin
  require 'delayed/tasks'
rescue LoadError => e
  puts "Cannot load tasks: #{e.inspect}"
end

