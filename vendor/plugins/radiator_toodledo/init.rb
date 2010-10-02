# Include hook code here

begin
  require 'toodledo_message_source'
  require 'yaml'
  
  home_dir = ENV["HOME"] || ENV["HOMEPATH"] || File::expand_path("~")
  toodledo_dir = File::join(home_dir, ".toodledo")
  config_file = File::join(toodledo_dir, "user-config.yml")
   
  toodledo_config = YAML.load(IO::read(config_file))
  
  Toodledo.set_config(toodledo_config)  
  
  toodledo_message_source = Radiator::ToodledoMessageSource.new
  MESSAGE_SOURCES << (toodledo_message_source)
  
rescue LoadError => e
  Rails.logger.error e.inspect
end

