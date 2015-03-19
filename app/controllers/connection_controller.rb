class ConnectionController < ApplicationController
  def index
    session[:referer] = nil
    @stats_hash = Roma.new.get_stats
    time = Time.now
    @default_start_time = (time - 7*24*60*60).strftime("%Y-%m-%dT%H:%M:%S")
    @current_time = time.strftime("%Y-%m-%dT%H:%M:%S")
  end

  def show
    if request.path_info != session[:referer]
      session[:referer] = request.path_info
      roma = Roma.new
      @stats_hash = roma.get_stats
      active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])

      if flash[:start_date] && flash[:end_date]
        @start_date = flash[:start_date]
        @end_date = flash[:end_date]
      else
        @start_date = view_context.add_00sec(params[:start_date])
        @end_date = view_context.add_00sec(params[:end_date])
      end
      
      logs_hash = roma.get_all_logs_by_date(active_routing_list, @start_date, @end_date)

      conn_count_data  = view_context.extract_conn_count(logs_hash)
      gon.connection_count = conn_count_data
      gon.connection_label = ['x', active_routing_list].flatten

      conn_source_data = view_context.extract_conn_source(logs_hash)
      gon.source_label = conn_source_data.keys
      gon.source_count = conn_source_data.values

    else
      redirect_to :action => "index"
    end
  end

  def update
    session[:referer] = nil
    flash[:start_date] = view_context.add_00sec(params[:start_date])
    flash[:end_date] = view_context.add_00sec(params[:end_date])
    redirect_to :action => "show"
  end
end
