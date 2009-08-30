require File.expand_path(File.dirname(__FILE__) +  '/../unit_test_helper')

class BetabriteControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = BetabriteController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
    
  def test_radiate_displays_message_on_betabrite
    BetabriteWriter.expects(:display).with(:some_node, :some_message, :some_color)
    
    get :radiate, :message => :some_message, :node => :some_node, :color => :some_color
    assert_response :success
  end
  
end