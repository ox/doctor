# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_status_icon(code)
    return case code
    when 1: #ALL GREEN
				 "status/status.png"
		when 2: #SOME ISSUES, NON FATAL
				 "status/status-away.png" 
	  when 3: #HOLY HELL!
				 "status/status-busy.png"
		when 4: #PATCH PATCH PATCH/EDIT EDIT EDIT
			  "status/bandaid.png"
		end
  end

  def evaluate_total_health(event)
    val = 0
    event.message.each_pair do |key, val|
      val += check_stability_of_system({key => val})
    end
    
    if val == even.message.keys.size
      return 1
    else
      return 3
    end
  end
  
  def render_appropriately(obj)
    key = obj.keys[0]
    hash = obj.values[0]
    
    return case key
    when 'mem_stats':
      #assume all megabytes, for now
      used = hash['Used']['number']
      total = hash['Total']['number']
      percentage_used = (used/total)*100
      "#{used}#{hash['Used']['unit']} used of #{total}#{hash['Used']['unit']}"
    when 'processes_summary':
      "#{hash['Sleeping']} Sleeping<br/> #{hash['Total']} Total<br/> #{hash['Threads']} Threads<br/> #{hash['Running']} Running"
    when 'server_load':
      l = hash['LoadAverages']
      "#{hash['Users']} Users<br/>Up for #{hash['UpTime']}<br/>Load Averages: #{l[0]}, #{l[1]}, #{l[2]}"
    when 'LoadAverages': #HACK, just the load averages, no users or uptime
      "#{hash[0]}, #{hash[1]}, #{hash[2]}"
    when 'cpu_usage':
      "#{hash['User']}% user<br/>#{hash['System']}% system<br/>#{hash['Idle']}% idle"
    when 'passenger_stats':
      if hash['Max'] == nil
        "Something is wrong with passenger-status. Could be permissions."
      else
        "#{hash['Max']} Max<br/>#{hash['Count']} Count<br/>#{hash['Active']} Active<br/>#{hash['Inactive']} Inactive<br/>#{hash['WaitingInGlobalQueue']} Waiting in global queue"
      end
    else
      hash
    end
  end
  
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
      end
    end
    
    return status
  end
end
