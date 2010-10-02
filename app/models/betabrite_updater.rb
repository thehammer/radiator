require 'rufus/scheduler'

#
# This class, when called, will show the messages in the queue.
#
class BetabriteUpdater
  
  def self.start_updater
    scheduler = Rufus::Scheduler.start_new

    scheduler.every '5s' do
      update_display
    end    

  end
  
  def self.update_display
    Message.transaction do
      message = Message.get_next_message
      return unless message
      
      BetabriteWriter.display(message.node, message.text, message.color)      

      message.last_displayed = Time.now
      message.save!      
    end    
  end
  
end