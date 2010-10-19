require 'toodledo'
require 'logging'

#
# This task dumps messages that can be read by radiator later.
#
module RadiatorToodledo
  class ToodledoMessageSource
    
    ONE_HOUR_IN_SECONDS = (60 * 60)
    
    def initialize
      @logger = Logging::Logger[self]
      @logger.level = :info
      @failure_time = nil
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
      app_id = "radiator"      
      
      session = ::Toodledo::Session.new(user_id, password, @logger, app_id)
      session.connect(base_url, proxy)
      session
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
    
      if (Time.now - @failure_time).to_i < (ONE_HOUR_IN_SECONDS + 60)
        logger.info "Returning because of excessive token requests"
        return
      end
    
      begin
        displayable_tasks = get_displayable_tasks
        Message.transaction do
          displayable_tasks.each do |task|
            truncated_title = task.title.slice(0, 60)
            logger.info "Pulling task: #{truncated_title}"

            Message.create(:text => truncated_title)
          end        
        end
      rescue Toodledo::InvalidKeyError => e
        Message.create(:text => e.message)
      rescue Toodledo::ExcessiveTokenRequestsError => e
        unless @failure_time
          @failure_time = Time.now
        end
        message = "Excessive token requests: failed at #{@failure_time}"
        Message.create(:text => message)
      rescue Exception => e
        Message.create(:text => e.message)
      end
    
      logger.info "Finished updating messages"
    end

  end
end
