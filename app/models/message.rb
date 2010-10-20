class Message < ActiveRecord::Base
  
  default_scope :order => 'last_displayed_at desc'
  
  validates_presence_of :text
  validates_presence_of :color
  validates_presence_of :node
  
  #
  # Gets the next message, starting with the ones that haven't been displayed in a while.
  #
  def self.get_next_message
    uncached do      
      messages = find(:all, :order => 'last_displayed_at desc')
      return nil if messages.empty?
      messages.first
    end
  end
  
  def self.clear_messages
    delete_all
  end
  
end