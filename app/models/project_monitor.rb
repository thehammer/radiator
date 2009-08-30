class ProjectMonitor
  
  def self.add(project, status)
    projects[project] = status
  end
  
  def self.clear_all
    @projects = {}
  end
  
  def self.projects
    @projects ||= {}
  end
  
  def self.remove(project)
    projects.delete project
  end
end