RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

%w{ ../vendor/betabrite/lib }.each do |path|
  $LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), path)))
end
$LOAD_PATH << File.dirname(__FILE__) + "/../app/betabrite"
$LOAD_PATH << File.dirname(__FILE__) + "/../app/plugins"

require File.dirname(__FILE__) + '/betabrite_configuration' if RAILS_ENV == 'production'

Rails::Initializer.run do |config|
  
  config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  config.action_controller.session = {
    :session_key => '_radiator_session',
    :secret      => '11fb03b9a51136d263f63a0afd495766f52d67353dabdb53e97a121808a03aa92a1fe6f81eab1ceaea9faa8b5f8f310ba7b96980b4dea3d546f9926344d86403'
  }
  
  config.gem 'haml'
  config.gem "chriseppstein-compass", :lib => 'compass', :version => '>= 0.6.1'
end