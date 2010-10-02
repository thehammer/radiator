require 'rufus/scheduler'

require_dependency 'betabrite/betabrite_writer'
require_dependency 'betabrite/usb_betabrite'

require_dependency 'message'

#
# This class, when called, will show the messages in the queue.
#
class BetabriteUpdater
  
  def self.update_display_resolution
    AppConfig.update_display
  end
  
  def self.update_messages_resolution
    AppConfig.update_display
  end
  
  def self.message_sources
    MESSAGE_SOURCES    
  end
  
  def self.start_updater
    scheduler = Rufus::Scheduler.start_new

    # Every 5 seconds, change the text.
    scheduler.every update_display_resolution do
      Message.transaction do        
        update_display
      end
    end    

    # Every minute, dump our existing messages and call for new ones.
    scheduler.every update_messages_resolution do
      Message.transaction do
        clear_messages
        update_messages
      end
    end

  end
  
  def self.clear_messages
    Message.clear_messages
  end
  
  def self.update_messages
    message_sources.each do |source|
      source.update_messages
    end
  end
  
  def self.update_display  
    message = Message.get_next_message
    return unless message
    
    BetabriteWriter.display(message.node, message.text, message.color)      

    message.last_displayed_at = Time.now
    message.save!      
  end
  
end