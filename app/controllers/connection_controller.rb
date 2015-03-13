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
      logs_hash = roma.get_all_logs_by_date(active_routing_list, view_context.add_00sec(params[:start_date]), view_context.add_00sec(params[:end_date]))

      conn_count_data  = view_context.extract_conn_count(logs_hash)
      gon.connection_count = conn_count_data
      gon.connection_label = ['x', active_routing_list].flatten

      conn_source_data = view_context.extract_conn_source(logs_hash)
      #gon.source_label = conn_source_data.keys
      #gon.source_count = conn_source_data.values
      gon.source_label = ["192.168.11.11", "192.168.11.12", "192.168.11.13", "192.168.11.14"]
      gon.source_count = [100, 234, 78, 88]
    else
      redirect_to :action => "index"
    end
  end
end
