class Message < ActiveRecord::Base
  
  default_scope :order => 'last_displayed_at asc'
  
  validates_presence_of :text
  validates_presence_of :color
  validates_presence_of :node
  
  #
  # Gets the next message, starting with the ones that haven't been displayed in a while.
  #
  def self.get_next_message
    
    # Return a never displayed message if there isn't one.
    uncached do
      message = find(:first, :conditions => { :last_displayed_at => nil })
      return message if message
    end

    # Otherwise, display the message that has been displayed least.  We have to do it this
    # way rather than combining it into a single query because the values will always get
    # sorted BEFORE null rather than after.
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