require File.expand_path('../boot', __FILE__)

require 'rails/all'

#$LOAD_PATH << File.dirname(__FILE__) + "/../lib/betabrite"

require File.dirname(__FILE__) + '/betabrite_configuration' if Rails.env == 'production'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Radiator
  class Application < Rails::Application
      
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end
