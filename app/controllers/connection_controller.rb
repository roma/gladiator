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

    gon.test_csv = @conn_count_data
    #gon.test_csv =
    #  "
    #    2015-03-13 08:19:07,3,3,3 
    #    2015-03-13 08:19:12,4,null,null 
    #    2015-03-13 08:19:15,5,4,4 
    #    2015-03-13 08:29:07,6,null,null 
    #    2015-03-13 08:32:35,6,null,null 
    #    2015-03-13 08:35:21,6,null,null 
    #    2015-03-13 08:37:56,6,null,null 
    #    2015-03-13 08:41:09,6,6,5 
    #    2015-03-13 08:42:47,6,6,5 
    #    2015-03-13 08:48:47,6,7,6 
    #    2015-03-13 08:50:56,6,7,6 
    #    2015-03-13 08:53:46,6,7,6 
    #    2015-03-13 08:57:06,6,7,6 
    #    2015-03-13 09:04:34,6,7,6 
    #    2015-03-13 09:05:47,6,7,6 
    #    2015-03-13 09:08:23,6,7,6 
    #    2015-03-13 09:12:08,6,6,6 
    #    2015-03-13 09:16:11,6,null,null 
    #    2015-03-13 09:18:22,6,null,null 
    #    2015-03-13 09:22:46,6,null,null 
    #    2015-03-13 09:26:02,6,null,null 
    #    2015-03-13 09:28:12,6,null,null 
    #    2015-03-13 09:30:37,6,6,6 
    #    2015-03-13 09:35:05,6,null,null 
    #    2015-03-13 09:37:44,6,null,null 
    #    2015-03-13 09:40:40,6,6,6 
    #    2015-03-13 09:46:52,6,7,6 
    #    2015-03-13 09:53:30,6,7,6 
    #    2015-03-13 10:01:23,6,null,null 
    #    2015-03-13 08:19:02,null,2,2 
    #    2015-03-13 08:19:17,null,5,5 
    #    2015-03-13 08:19:39,null,6,null 
    #    2015-03-13 08:35:22,null,6,5 
    #    2015-03-13 08:37:57,null,6,5 
    #    2015-03-13 08:42:52,null,7,6 
    #    2015-03-13 09:23:00,null,6,6 
    #    2015-03-13 09:26:03,null,6,6 
    #    2015-03-13 09:28:13,null,6,6 
    #    2015-03-13 09:35:08,null,6,6 
    #    2015-03-13 09:37:45,null,6,6 
    #    2015-03-13 09:42:08,null,7,null 
    #    2015-03-13 09:43:31,null,7,6 
    #    2015-03-13 09:49:29,null,7,6 
    #  "



 #@conn_count_data


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
