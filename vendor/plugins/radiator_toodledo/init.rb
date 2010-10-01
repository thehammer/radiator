# Include hook code here

begin
  require 'radiator_toodledo'
  
  # Register toodledo as a datasource.
rescue LoadError => e
  Rails.logger.warn 'Unable to load textfilter'
end

