class UpdateDisplayJob < Struct.new(:source)
  
  def logger
    Logging::Logger[self]
  end
  
  def perform
    logger.info "Updating display"

    Message.benchmark("Update Display Job") do
      Message.transaction do        
        message = Message.get_next_message
        return unless message
        logger.info "Showing new message #{message.text}"

        BetabriteWriter.display(message.node, message.text, message.color)      

        message.last_displayed_at = Time.now
        message.save!      
      end
    end
  end
end
