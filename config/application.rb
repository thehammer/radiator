require File.expand_path('../boot', __FILE__)

require 'rails/all'

require File.expand_path('../betabrite_configuration', __FILE__) if Rails.env == 'production'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

MESSAGE_SOURCES = []

module Radiator
  class Application < Rails::Application
      
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]    
    
  end
end
