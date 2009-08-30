require File.expand_path(File.dirname(__FILE__) +  '/../unit_test_helper')

class ContinuousIntegrationControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = ContinuousIntegrationController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
    
  def test_radiate_displays_project_status_on_betabrite
    BetabriteWriter.expects(:display).with("a", "some project - some status", "0000FF")
    get :radiate, :project => "some project", :status => "some status"
    assert_response :success
  end

  def test_radiate_displays_multiple_project_status_on_betabrite
    BetabriteWriter.expects(:display).with("a", "project a - status a", "0000FF")
    get :radiate, :project => "project a", :status => "status a"
    assert_response :success

    BetabriteWriter.expects(:display).with("a", "project a - status a", "0000FF")
    BetabriteWriter.expects(:display).with("b", "project b - status b", "0000FF")
    get :radiate, :project => "project b", :status => "status b"
    assert_response :success
  end
  
  def test_radiate_displays_projects_in_alphabetical_order
    BetabriteWriter.expects(:display).with("a", "C - 3", "0000FF")
    get :radiate, :project => "C", :status => "3"
    assert_response :success    

    BetabriteWriter.expects(:display).with("a", "A - 1", "0000FF")
    BetabriteWriter.expects(:display).with("b", "C - 3", "0000FF")
    get :radiate, :project => "A", :status => "1"
    assert_response :success

    BetabriteWriter.expects(:display).with("a", "A - 1", "0000FF")
    BetabriteWriter.expects(:display).with("b", "B - 2", "0000FF")
    BetabriteWriter.expects(:display).with("c", "C - 3", "0000FF")
    get :radiate, :project => "B", :status => "2"
    assert_response :success    
  end
  
  def test_dim_removes_project_from_display
    ProjectMonitor.projects["A"] = "1"
    ProjectMonitor.projects["B"] = "2"

    BetabriteWriter.expects(:display).with("a", "B - 2", "0000FF")
    get :dim, :project => "A"
    assert_response :success    
  end
  
  def teardown
    ProjectMonitor.clear_all
  end

end
