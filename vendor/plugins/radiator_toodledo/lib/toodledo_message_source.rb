require 'toodledo'

#
# This task dumps messages that can be read by radiator later.
#
module Radiator
  class ToodledoMessageSource

    def initialize
      config = ::Toodledo.get_config()
      proxy = config['proxy']

      connection = config['connection']
      base_url = connection['url']
      user_id = connection['user_id']
      password = connection['password']
      app_id = connection['app_id'] || 'ruby_app'      
      logger = Logger.new("log/toodledo.log")
      logger.level = Logger::ERROR
      
      @session = ::Toodledo::Session.new(user_id, password, logger, app_id)
      @session.connect(base_url, proxy)      
    end
    
    def update_messages  
      options = { :star => true, :folder => 'Action', :notcomp => true }
      tasks = @session.get_tasks(options)
      Message.transaction do
        tasks.each do |task|
          truncated_title = task.title.slice(0, 60)
          Message.create(:text => truncated_title)
        end        
      end
    end

  end
end
