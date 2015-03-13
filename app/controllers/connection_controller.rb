class ConnectionController < ApplicationController
  def index
    #session[:referer] = nil
    @stats_hash = Roma.new.get_stats
    time = Time.now
    @default_start_time = (time - 7*24*60*60).strftime("%Y-%m-%dT%H:%M:%S")
    @current_time = time.strftime("%Y-%m-%dT%H:%M:%S")
    gon.test_csv = view_context.debug
  end

  def show
    #if request.path_info != session[:referer]
    #  session[:referer] = request.path_info
      roma = Roma.new
      @stats_hash = roma.get_stats
      active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
    #  gon.routing_list = active_routing_list.map{|instance|
    #    self.class.helpers.compact_instance(instance)
    #  }

    #  if @stats_hash["routing"]["min_version"].to_i < 65792 #v1.1.0
    #    @raw_logs = roma.get_all_logs(active_routing_list)
    #  else # after v1.1.0
        logs_hash = roma.get_all_logs_by_date(active_routing_list, view_context.add_00sec(params[:start_date]), view_context.add_00sec(params[:end_date]))

    @conn_count_data  = view_context.extract_conn_count(logs_hash)
    @conn_source_data = view_context.extract_conn_source(logs_hash)

    #render :text => @conn_count_data
    #    @gathered_time
    #    logs_hash.each{|instance, logs_array|
    #      @gathered_time = logs_hash[instance].shift
    #      logs_hash[instance].shift unless logs_array[0] =~ /INFO|DEBUG|WARN|ERROR/ #remove log file created line
    #    }
    #    @raw_logs = logs_hash
    #  end
    #else
    #  redirect_to :action => "index"
    #end
  end

  #def update
  #  session[:referer] = nil
  #  redirect_to :action => "show_logs"
  #end

end
