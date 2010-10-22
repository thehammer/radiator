class UpdateDisplayJob < Struct.new(:source)
  
  def logger
    Logging::Logger[self]
  end
  
  def perform
    logger.info "Updating display"

    Message.benchmark("Update Display Job") do
      Message.transaction do        
        message = Message.get_next_message
        
        if message        
          logger.info "Showing new message #{message.id} (last_displayed_at = #{message.last_displayed_at}) = #{message.text}"
          message.last_displayed_at = Time.now
          message.save!      
          display(message.node, message.text, message.color)
        else
          logger.info "Showing default message"
          display(Message.default_node, Message.default_message, Message.default_color)          
        end        
      end
    end        
  end
  
  def display(node, text, color)    
    BetabriteWriter.display(node, text, color)
  end
  
end
