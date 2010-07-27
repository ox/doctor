require 'json'

class Stethoscope < ActiveRecord::Base
  has_many :routines, :dependent => :destroy
  
  def get_status
    call_list = ""
    routines.each do |routine|
      call_list << "#{routine.name}:"
    end

    hashed_result = JSON.parse `curl #{server}/#{call_list}`
    
    hashed_result.keys.each do |key|
      routines.find_by_name(key).perform({key => hashed_result[key]})
    end

  rescue => exception
    routines.each do |r|
      r.perform({:error => exception})
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
