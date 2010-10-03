# Include hook code here

begin
  require 'toodledo_message_source'
  require 'yaml'
  
  home_dir = ENV["HOME"] || ENV["HOMEPATH"] || File::expand_path("~")
  toodledo_dir = File::join(home_dir, ".toodledo")
  config_file = File::join(toodledo_dir, "user-config.yml")
   
  toodledo_config = YAML.load(IO::read(config_file))
  
  Toodledo.set_config(toodledo_config)  

  toodledo_message_source = RadiatorToodledo::ToodledoMessageSource.new
  AppConfig.message_sources.push(toodledo_message_source)
  
rescue LoadError => e
  puts e.inspect
  Rails.logger.error e.inspect
end

