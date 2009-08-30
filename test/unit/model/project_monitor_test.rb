require File.expand_path(File.dirname(__FILE__) +   '/../unit_test_helper')

class ProjectMonitorTest < Test::Unit::TestCase
  
  def test_add_inserts_project_and_status_into_hash
    ProjectMonitor.add :a_project, :a_status
    assert_equal :a_status, ProjectMonitor.projects[:a_project]
  end
  
  def test_add_updates_project_and_status_when_they_already_exist
    ProjectMonitor.add :a_project, :a_status
    assert_equal :a_status, ProjectMonitor.projects[:a_project]

    ProjectMonitor.add :a_project, :another_status
    assert_equal :another_status, ProjectMonitor.projects[:a_project]
  end
  
  def test_clear_all_restarts_project_tracking
    ProjectMonitor.add :a_project, :a_status
    assert ProjectMonitor.projects.any?
    
    ProjectMonitor.clear_all
    assert ProjectMonitor.projects.empty?
  end

  def test_remove_stops_tracking_project
    ProjectMonitor.add :a_project, :a_status
    ProjectMonitor.remove :a_project
    
    assert_nil ProjectMonitor.projects[:a_project]
  end
  
  def test_tracks_multiple_projects
    ProjectMonitor.add :a_project, :a_status
    ProjectMonitor.add :b_project, :b_status
    assert_equal :a_status, ProjectMonitor.projects[:a_project]
    assert_equal :b_status, ProjectMonitor.projects[:b_project]
  end
  
  def teardown
    ProjectMonitor.clear_all
  end
  
end