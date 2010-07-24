require 'json'

class Stethoscope < ActiveRecord::Base
  has_many :routines, :dependent => :destroy
  
  def get_status
    routines.each do |routine|
      routine.perform
    end
  end
    
    # status = JSON.parse`curl #{server}/`
    # if status
    #   result = check_stability_of_system(status)
    #   event = Event.create(:status => result, :message => status)
    #   events << event
    # end
  # rescue
  #     events << Event.new(:status => 3, :message => {'ran' => "Stethoscope did not respond"})
  #     puts "#{server} might not be running Stethoscope"
end
