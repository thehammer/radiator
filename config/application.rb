require File.expand_path('../boot', __FILE__)

require 'logging'
require 'rails/all'

require File.expand_path('../app_config', __FILE__)
require File.expand_path('../betabrite_configuration', __FILE__) if Rails.env == 'production'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

root_logger = Logging::Logger.root
root_logger.add_appenders(
  Logging.appenders.stdout,
  Logging.appenders.rolling_file("log/#{Rails.env}.log")
)
root_logger.level = :debug
Rails.logger = root_logger

# Thanks to http://twitter.com/#!/svenfuchs/status/12001807009
Rails::Rack::LogTailer.class_eval do 
  def initialize(app, log = nil)
    @app = app
  end

  def call(env)
    response = @app.call(env)
    tail!
    response
  end

  def tail! 
    # STFU 
  end 
end

module Radiator
  class Application < Rails::Application
      
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]    

    config.autoload_paths << 'lib/betabrite'

    # Can't believe inserting ANSI color codes is the default...
    config.colorize_logging = false    

    config.after_initialize do 
      BetabriteUpdater.start_updater
    end
  end
end

