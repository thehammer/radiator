# To use the notifier for all the projects on a cc.rb server:
#   Create a radiator_notifier.yml file with one line:
#   default_radiator: http://localhost:8374/continuous_integration
#
# Sample per project configuration:
# <pre><code>Project.configure do |project|
#   ...
#   project.radiator_notifier.radiators = ['http://localhost:8374/continuous_integration']
#   project.radiator_notifier.building_rgb   = RadiatorNotifier::Yellow
#   project.radiator_notifier.successful_rgb = RadiatorNotifier::Green
#   project.radiator_notifier.failed_rgb     = RadiatorNotifier::Red
#   ...
# end</code></pre>

require 'net/http'
require 'timeout'

class RadiatorNotifier
  Red = "FF0000"
  Yellow = "77FF00"
  Green = "00FF00"
  Blue = "0000FF"
  
  attr_accessor :radiators, :building_rgb, :successful_rgb, :failed_rgb
  
  def self.shared_settings
    YAML.load_file(File.join(RAILS_ROOT, "config", "radiator_notifier.yml")) rescue nil
  end
  
  def self.default_radiator
    shared_settings["default_radiator"] if shared_settings
  end
  
  def initialize(project = nil)
    @radiators = [RadiatorNotifier.default_radiator].compact
    @building_rgb = Yellow
    @successful_rgb = Green
    @failed_rgb = Red
  end

  def build_started(build)
    radiate build.project.name, "BUILDING", building_rgb
  end

  def build_finished(build)
    if build.successful?
      radiate build.project.name, "SUCCESSFUL", successful_rgb
    else
      radiate build.project.name, "FAILED", failed_rgb
    end
  end

  private
  
  def radiate(project, status, color)
    @radiators.each do |radiator|
      begin
        Timeout.timeout(15) do
          Net::HTTP.get_response URI.parse("#{radiator}/radiate/#{project}/#{status}?color=#{color}")
        end
      rescue StandardError, Timeout::Error => e
        puts "Error connecting to Radiator #{radiator}, #{e}"
      end
    end
  end

end

Project.plugin :radiator_notifier if defined? Project
