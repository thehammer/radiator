# Load application configuration
require 'ostruct'
require 'yaml'

config_file = File.expand_path('../config.yml', __FILE__)

config = YAML.load_file(config_file) || {}
app_config = config['common'] || {}
app_config.update(config[Rails.env] || {})
app_config[:message_sources] = []
AppConfig = OpenStruct.new(app_config)