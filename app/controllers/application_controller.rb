# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout 'default'

  helper :all # include all helpers, all the time

  protect_from_forgery
  
end
