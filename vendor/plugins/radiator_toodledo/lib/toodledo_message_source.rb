require 'toodledo'
require 'logging'

#
# This task dumps messages that can be read by radiator later.
#
module RadiatorToodledo
  class ToodledoMessageSource
    
    def initialize
      @logger = Logging::Logger[self]
      @logger.level = :info      
    end
    
    def logger
      @logger
    end

    def get_session
      config = ::Toodledo.get_config()
      proxy = config['proxy']

      connection = config['connection']
      base_url = connection['url']
      user_id = connection['user_id']
      password = connection['password']
      app_id = connection['app_id'] || 'ruby_app'      
    
      session = ::Toodledo::Session.new(user_id, password, @logger, app_id)   
    end
    
    def get_displayable_tasks
      today = Date.today.strftime("%Y-%m-%d")

      session = get_session
      starred_tasks = session.get_tasks({ :star => true, :notcomp => true })
      overdue_tasks = session.get_tasks({ :before => today, :notcomp => true })
      all_tasks = starred_tasks + overdue_tasks
      all_tasks
    end
    
    def update_messages
      logger.info "Updating messages from toodledo:"
    
      displayable_tasks = get_displayable_tasks
      Message.transaction do
        displayable_tasks.each do |task|
          truncated_title = task.title.slice(0, 60)
          logger.info "Pulling task: #{truncated_title}"
          
          Message.create(:text => truncated_title)
        end        
      end
      
      logger.info "Finished updating messages"
    end

  end
end
