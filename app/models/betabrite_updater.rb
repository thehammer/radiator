require 'rufus/scheduler'
require 'betabrite/betabrite_writer'
require 'betabrite/usb_betabrite'

#
# This class, when called, will show the messages in the queue.
#
class BetabriteUpdater
  
  def self.start_updater
    Rails.logger.info "start_updater: "
    
    scheduler = Rufus::Scheduler.start_new

    scheduler.every '5s' do
      update_display
    end    

  end
  
  def self.update_display
    message = Message.get_next_message
    Rails.logger.info "update_display: message = #{message.inspect}"
    return unless message
    
    BetabriteWriter.display(message.node, message.text, message.color)      

    message.last_displayed_at = Time.now
    message.save!      
  end
  
end