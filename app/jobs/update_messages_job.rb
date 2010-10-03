class UpdateMessagesJob < Struct.new(:source)
  
  def logger
    Logging::Logger[self]
  end
  
  def message_sources
    AppConfig.message_sources    
  end
  
  def perform
    logger.debug "Updater: Updating Messages"

    Message.benchmark("Updating Messages") do
      Message.transaction do
        Message.clear_messages

        message_sources.each do |source|
          source.update_messages
        end
      end
    end
  end
  
end
