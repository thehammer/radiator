require 'rufus/scheduler'
require 'betabrite/betabrite_writer'
require 'betabrite/usb_betabrite'

#
# This class, when called, will show the messages in the queue.
#
class BetabriteUpdater
  
  def self.start_updater
    scheduler = Rufus::Scheduler.start_new

    # Every 5 seconds, change the text.
    scheduler.every '5s' do
      update_display
    end    

    # Every minute, dump our existing messages and call for new ones.
    scheduler.every "1m" do
      clear_messages
      update_messages
    end

  end
  
  def self.clear_messages
    Message.clear_messages
  end
  
  def self.update_messages
    sources = MESSAGE_SOURCES
    sources.each do |source|
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