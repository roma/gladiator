require 'gladiator_exception'

class ApplicationController < ActionController::Base
  before_filter :check_logined_filter, :check_mklhash, :unsupport_version?
  helper_method :login_check?
  protect_from_forgery with: :exception

  rescue_from Exception,                        with: :render_500
  rescue_from ConPoolError,                     with: :change_base
  rescue_from UnsupportedError,                 with: :confirm_unsupport
  rescue_from ActionController::RoutingError,   with: :render_404

  def change_base
    Rails.logger.warn("ConPoolError happened")
    Rails.logger.debug("session[:active_routing_list] => #{session[:active_routing_list]}")

    if session[:active_routing_list]
      if session[:active_routing_list].size == 1
        Rails.logger.error("All instaces were down")
        $baseHost = nil
        $basePort = nil
        render_500 Errno::ECONNREFUSED.new
        return
      else
        session[:active_routing_list].each{|instance|
          begin
            Roma.new.send_command('whoami', nil, instance.split(/[:_]/)[0], instance.split(/[:_]/)[1])

            $baseHost = instance.split(/[:_]/)[0]
            $basePort = instance.split(/[:_]/)[1]
            Rails.logger.warn("changed base instance => #{$baseHost}_#{$basePort}")
            redirect_to :action => "index"
            return
          rescue
            next
          end 
        }

        Rails.logger.error("All instaces were down")
        render_500 Errno::ECONNREFUSED.new
      end
    else
      Rails.logger.error("session[:active_routing_list] do NOT exists!")
      render_500 Errno::ECONNREFUSED.new
    end
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_404(exception = nil)
    if exception
      logger.error "Rendering 404 with exception: #{exception.message}"
    end

    unexpected_url = "http://#{request.host}:#{request.port.to_s + request.fullpath}"
    render :template => "errors/error_404", :locals => {:unexpected_url => unexpected_url}, :status => 404, :layout => 'application'
  end

  def render_500(exception = nil)
    if exception
      logger.error "Rendering 500 with exception: #{exception.message}"
    end
    render :template => "errors/error_500", :locals => {:ex => exception}, :status => 500, :layout => 'application'
  end

  def confirm_unsupport
    render :template => "errors/unsupport", :layout => 'application'
  end

  private
  def login_check?
    if session[:username] && session[:password] && User.authenticate(session[:username], session[:password])
      return true
    end
    false
  end

  def unsupport_version?
    raise UnsupportedError if flash[:unsupport]
  end

  def check_logined_filter
    flash[:referer] = request.fullpath

    if session[:username] && session[:password]
      begin
        raise if !User.authenticate(session[:username], session[:password])
      rescue
        reset_session
        flash[:login_error] = "illegal user data!!"
        redirect_to :controller => 'login', :action => 'index'
      end
    else
      flash[:login_error] = "please login!!"
        redirect_to :controller => 'login', :action => 'index'
    end
  end

  def check_mklhash
    roma = Roma.new
    current_mklhash = roma.send_command("mklhash 0", nil)
    unless current_mklhash == session[:mklhash]
      stats_hash = roma.get_stats
      session[:active_routing_list] = roma.change_roma_res_style(stats_hash["routing"]["nodes"])
      session[:mklhash] = current_mklhash
      Rails.logger.warn('Remake routing information')
      Rails.logger.warn("session[:active_routing_list] => #{session[:active_routing_list]}")
      Rails.logger.warn("session[:mklhash] => #{session[:mklhash]}")
    end
  end

end
