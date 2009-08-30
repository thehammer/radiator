require File.expand_path(File.dirname(__FILE__) +  '/../unit_test_helper')
require 'radiator_notifier'

class RadiatorNotifierTest < Test::Unit::TestCase
  MOCK_HOST = "http://mock.host:port/ci"
  
  def setup
    @notifier = RadiatorNotifier.new
    @notifier.radiators = [ MOCK_HOST ]
  end
  
  def test_default_radiator_is_empty_array_if_no_shared_settings_detected
    assert_equal nil, RadiatorNotifier.default_radiator
  end

  def test_default_radiator_is_default_raditor_in_an_arry_if_set
    RadiatorNotifier.stubs(:shared_settings).returns("default_radiator" => :raditor_app_url)
    assert_equal :raditor_app_url, RadiatorNotifier.default_radiator
  end
  
  def test_project_raditors_has_only_the_default_one_if_none_is_specified
    RadiatorNotifier.stubs(:default_radiator).returns(:another_host)
    notifier = RadiatorNotifier.new
    assert_equal [:another_host], notifier.radiators
  end

  def test_app_raditors_is_initially_empty_array_if_no_default_is_specified
    RadiatorNotifier.stubs(:default_radiator).returns(nil)
    notifier = RadiatorNotifier.new
    assert_equal [], notifier.radiators
  end
    
  def test_build_started
    build = stub(:project => stub(:name => "some_build"))

    URI.expects(:parse).with(MOCK_HOST + "/radiate/some_build/BUILDING?color=77FF00").returns(:uri)
    Net::HTTP.expects(:get_response).with(:uri)
    
    @notifier.build_started build 
  end

  def test_build_successful
    build = stub(:project => stub(:name => "some_build"), :successful? => true)

    URI.expects(:parse).with(MOCK_HOST + "/radiate/some_build/SUCCESSFUL?color=00FF00").returns(:uri)
    Net::HTTP.expects(:get_response).with(:uri)
    
    @notifier.build_finished build 
  end

  def test_build_failed
    build = stub(:project => stub(:name => "some_build"), :successful? => false)

    URI.expects(:parse).with(MOCK_HOST + "/radiate/some_build/FAILED?color=FF0000").returns(:uri)
    Net::HTTP.expects(:get_response).with(:uri)
    
    @notifier.build_finished build 
  end

end