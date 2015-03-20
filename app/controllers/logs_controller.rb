class LogsController < ApplicationController
  def index
    session[:referer] = nil
    @stats_hash = Roma.new.get_stats
    time = Time.now
    @default_start_time = (time - 7*24*60*60).strftime("%Y/%m/%d %H:%M")
    @current_time = time.strftime("%Y/%m/%d %H:%M")
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

      if @stats_hash["routing"]["min_version"].to_i < Constants::VERSION_1_1_0
        @raw_logs = roma.get_all_logs(active_routing_list)
      else # after v1.1.0
        if flash[:start_date] && flash[:end_date]
          @start_date = flash[:start_date]
          @end_date = flash[:end_date]
        else
          @start_date = params[:start_date]
          @end_date = params[:end_date]
        end
        logs_hash = roma.get_all_logs_by_date(active_routing_list, view_context.change_iso8601(@start_date), view_context.change_iso8601(@end_date))
        logs_hash.each{|instance, logs_array|
          @gathered_time = logs_hash[instance].shift
          logs_hash[instance].shift unless logs_array[0] =~ /INFO|DEBUG|WARN|ERROR/ #remove log file created line
        }
        @gathered_time =~ /^(\d+)-(\d+)-(\d+)\s(\d+):(\d+):(\d+)/
        @gathered_time = Time.mktime($1, $2, $3, $4, $5, $6)
        @raw_logs = logs_hash
      end
    else
      redirect_to :action => "index"
    end
  end

  def update
    session[:referer] = nil
    if params[:start_date] && params[:end_date]
      flash[:start_date] = params[:start_date]
      flash[:end_date] = params[:end_date]
    end
    redirect_to :action => "show_logs"
  end

end
