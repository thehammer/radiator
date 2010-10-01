require 'coderay'
require 'htmlentities'
require 'toodledo'

#
# This class provides a datasource to radiator which pulls important tasks from Toodledo.
#
class Radiator
  class Toodledo

    def initialize
      @session = Toodledo::Session
    end
    
    def pull_one      
      options = { :priority => 1 }
      @session.find_tasks(options)      
    end

  end
end
