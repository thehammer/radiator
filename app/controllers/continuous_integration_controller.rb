require 'project_monitor'
require 'timeout'
require 'betabrite_writer'

class ContinuousIntegrationController < ApplicationController
  after_filter :refresh_display
  
  def dim
    ProjectMonitor.remove params[:project]
  end

  def radiate
    status = params[:color] ? colorize(params[:status], params[:color]) : params[:status]
    ProjectMonitor.add params[:project], status
  end

  protected 

  def colorize(s, color)
    0x1C.chr + "Z" + color + s
  end
  
  def refresh_display
    ProjectMonitor.projects.keys.sort.each_with_index do |project, index|
      status = ProjectMonitor.projects[project]
      node = ('a'..'j').to_a[index] or raise "Too many projects!"
      
      BetabriteWriter.display(node, "#{project} - #{status}", "0000FF")
    end
  end
  
end