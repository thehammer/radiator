class Message < ActiveRecord::Base
  
  default_scope :order => 'last_displayed_at asc'
  
  validates_presence_of :text
  validates_presence_of :color
  validates_presence_of :node
  
  #
  # Gets the next message, starting with the ones that haven't been displayed in a while.
  #
  def self.get_next_message
    uncached do      
      messages = find(:all, :order => 'last_displayed_at asc')
      return nil if messages.empty?
      messages.first
    end
  end
  
  def self.clear_messages
    delete_all
  end
  
  def self.default_color
    "0000FF"
  end
  
  def self.default_node
    "1"
  end
  
  def self.default_message
    DateTime.now.strftime("%m/%d/%y %H:%M:%S")
  end
  
end