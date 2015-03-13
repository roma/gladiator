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
    roma = Roma.new
    @stats_hash = roma.get_stats
    active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
    logs_hash = roma.get_all_logs_by_date(active_routing_list, view_context.add_00sec(params[:start_date]), view_context.add_00sec(params[:end_date]))
    @conn_count_data  = view_context.extract_conn_count(logs_hash)
    @conn_source_data = view_context.extract_conn_source(logs_hash)
    gon.connection_count = @conn_count_data
    gon.label = ['x', active_routing_list].flatten
  end

end
