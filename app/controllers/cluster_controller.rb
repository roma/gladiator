class ClusterController < ApplicationController

  def index
    roma = Roma.new

    @stats_hash = roma.get_stats
    @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
    gon.active_routing_list = @active_routing_list

    @inactive_routing_list = roma.get_all_routing_list - @active_routing_list
    begin
      @routing_info = roma.get_routing_info(@active_routing_list)
      @routing_info.each{|instance, info|
        flash.now[:no_response] = instance if info.has_value?("no_response")
        case info["status"]
        when "release"
          gon.host, gon.port = instance.split(/_/) 
          # in case of release was executing by console or login by other users
          if !session[:denominator]
            session[:denominator] = info["primary_nodes"]
            (info["redundant"]-1).times{|i|
              session[:denominator] += info["secondary_nodes#{i+1}"] 
            }
 
          end
          gon.denominator = session[:denominator]
          gon.routing_info = @routing_info
        when "join"
          gon.host, gon.port = instance.split(/_/)
          gon.routing_info = @routing_info
        when "recover"
          gon.host, gon.port = instance.split(/_/) 
          if !session[:denominator]
            session[:denominator] = @stats_hash["routing"]["short_vnodes"]
          end
          gon.denominator = session[:denominator]
          gon.routing_info = @routing_info
        end
      }
    rescue ConPoolError
      Rails.logger.error("rescued ConPoolError in cluster Controller")
      @routing_info = {}
      gon.just_booting = true
    rescue Errno::ECONNREFUSED
      Rails.logger.warn("rescued Errno::ECONNREFUSED in cluster Controller")
      @routing_info = {}
      gon.just_booting = true
    end
  end

  def destroy #[rbalse]
    host, port = params[:target_instance].split(/_/)

    roma = Roma.new

    if session[:released]
      if session[:released] == "#{host}_#{port}"
        session[:released] = nil
        session[:denominator] = nil
        res = roma.send_command('rbalse', nil, host, port) 
      else
        flash[:error_message] = "Please rbalse #{session[:released]} before that"
      end
    else
      res = roma.send_command('rbalse', nil, host, port) 
    end

    redirect_to(:action => "index")
  end

  def update #[recover]
    gon.host = $baseHost
    gon.port = $basePort

    roma = Roma.new
    res = roma.send_command('recover', nil) 

    @stats_hash = roma.get_stats
    @active_routing_list = roma.get_active_routing_list(@stats_hash)
    @inactive_routing_list = roma.get_all_routing_list - @active_routing_list
    @routing_info = roma.get_routing_info(@active_routing_list)
    gon.routing_info = @routing_info
    gon.denominator = @stats_hash["routing"]["short_vnodes"]
    session[:denominator] = gon.denominator

    render :action => "index"
  end

  def release #[release]
    host, port = params[:target_instance].split(/_/)
    gon.host = host
    gon.port = port

    roma = Roma.new
    res = roma.send_command('release', nil, host, port) 
    session[:released] = params[:target_instance]

    @stats_hash = roma.get_stats
    @active_routing_list = roma.get_active_routing_list(@stats_hash)
    @inactive_routing_list = roma.get_all_routing_list - @active_routing_list
    @routing_info = roma.get_routing_info(@active_routing_list)
    gon.routing_info = @routing_info
    session[:denominator] = @routing_info[params[:target_instance]]["primary_nodes"]
    (@stats_hash["routing"]["redundant"].to_i - 1).times{|i|
      session[:denominator] += @routing_info[params[:target_instance]]["secondary_nodes#{i+1}"]
    }
    gon.denominator = session[:denominator]

    render :action => "index"
  end
end
