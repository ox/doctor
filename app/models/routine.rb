require 'json'

class Routine < ActiveRecord::Base
  belongs_to :stethoscope
  has_many :events, :dependent => :destroy
  
  def perform(hashed_result)
    events << Event.new(:status => check_stability(hashed_result), :returned => hashed_result)
    
  rescue => exception
    puts exception
    puts exception.backtrace
    events << Event.new(:status => 3, :returned => { :error => "Server may not be running Stethoscope. Returned: #{hashed_result['error']}"} )
  end

private
  def check_stability(obj)
    #1 = good
    #2 = warning
    #3 = bad/off
    status = 1
    
    obj.each_pair do |k,v|
      case k
      when 'mem_stats':
        #check that there is enough memory left
        used = v['Used']['number']
        total = v['Wired']['number'] + v['Active']['number'] + v['Inactive']['number'] + v['Free']['number']
        percentage_used = (used/total)*100
        case percentage_used
        when 0..75:
          status = 1
        when 76..94:
          status = 2
        when 95..100:
          status = 3
        end
      when 'number_of_resque_processes':
        if v > 0
          status = 1
        else
          status = 3
        end
      when 'hostname':
        if v != ''
          status = 1
        else
          status = 3
        end
      when 'error':
        status = 3
        raise "error because of #{v}"
      end
    end
    
    return status
  end
end
