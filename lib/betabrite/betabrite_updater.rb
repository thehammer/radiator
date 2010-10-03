require 'rufus/scheduler'

#
# This class, when called, will show the messages in the queue.
#
class BetabriteUpdater
  
  def self.update_display_resolution
    AppConfig.update_display
  end
  
  def self.update_messages_resolution
    AppConfig.update_messages
  end
  
  def self.start_updater
    Rails.logger.info "Display Resolution: #{update_display_resolution}"
    Rails.logger.info "Message Resolution: #{update_messages_resolution}"

    scheduler = Rufus::Scheduler.start_new

    # Every 5 seconds, change the text.
    scheduler.every update_display_resolution do
      Delayed::Job.enqueue UpdateDisplayJob.new('updater')
    end    

    # Every minute, dump our existing messages and call for new ones.
    scheduler.every update_messages_resolution do
      Delayed::Job.enqueue UpdateMessagesJob.new("updater")     
    end
  end
  
end