class LogsController < ApplicationController
  def index
    session[:referer] = nil
    @stats_hash = Roma.new.get_stats
  end

  def show_logs
    if request.path_info != session[:referer]
      session[:referer] = request.path_info
      roma = Roma.new
      @stats_hash = roma.get_stats
      active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
      gon.routing_list = active_routing_list.map{|instance|
        self.class.helpers.compact_instance(instance)
      }
      
      if @stats_hash["others"]["version"] == "1.0.0"
        @raw_logs = roma.get_all_logs(active_routing_list)
      else
        logs_hash = roma.get_all_logs_by_date(active_routing_list)
        @gathered_time
        logs_hash.each{|instance, logs_array|
          @gathered_time = logs_hash[instance].shift
          logs_hash[instance].shift unless logs_array[0] =~ /INFO|DEBUG|WARN|ERROR/ #remove log file created line
        }
        @raw_logs = logs_hash
      end
    else
      redirect_to :action => "index"
    end
  end

  def update
    session[:referer] = nil
    redirect_to :action => "show_logs"
  end

end
