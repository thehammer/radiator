class Message < ActiveRecord::Base
  
  default_scope :order => 'last_displayed_at asc'
  
  validates_presence_of :text
  validates_presence_of :color
  validates_presence_of :node
  
  #
  # Gets the next message, starting with the ones that haven't been displayed in a while.
  #
  def self.get_next_message
    messages = Message.first(:order => 'last_displayed_at asc')    
    return nil if messages.empty?
    messages.first 
  end
  
  def self.clear_messages
    delete_all
  end
  
end