class LoginController < ApplicationController
  skip_before_filter :check_logined_filter, :check_mklhash, :unsupport_version?
  before_filter :redirect_top?, :only => 'index'
  
  def auth
    usr, type = User.authenticate(params['username'], Digest::SHA1.hexdigest(params['password']))
    if usr && type
      session[:username] = usr[:username]
      session[:password] = Digest::SHA1.hexdigest(usr[:password])
      session[:user_type] = type
      if usr[:email]
        session[:email] = usr[:email]
      else
        session[:email] = ''
      end

      roma = Roma.new
      stats_hash = roma.get_stats

      ###Version check(ROMA main unit)
      version = self.class.helpers.chk_roma_version(stats_hash['others']['version'])
      case version
      when 0..2058 # earlier than v0.8.10 
        reset_session
        flash[:login_error] = "Gladiator don't support the version older than v0.8.11."
        redirect_to :action => 'index' and return
      when 2059..65535 # v0.8.11 - v0.8.14
        flash[:login_error] = 'unsupport version'
        flash[:unsupport] = stats_hash['others']['version']
      when 65536..Float::INFINITY # over 1.0.0
        # nothing
      end

      ###plugin check(config_gui.rb)
      unless roma.change_roma_res_style(stats_hash['config']['PLUGIN_FILES']).include?('plugin_gui.rb')
        Rails.logger.error("ROMA can NOT find 'plugin_gui.rb' plugin.")
        reset_session
        flash[:login_error] = 'missing plugin'
        redirect_to :action => 'index' and return
      end

      session[:active_routing_list] = roma.change_roma_res_style(stats_hash["routing"]["nodes"])
      session[:mklhash] = roma.send_command("mklhash 0", nil)
      $baseHost = session[:active_routing_list][0].split(/[:_]/)[0]
      $basePort = session[:active_routing_list][0].split(/[:_]/)[1]
      Rails.logger.debug("session[:active_routing_list] => #{session[:active_routing_list]}")
      Rails.logger.debug("session[:mklhash] => #{session[:mklhash]}")
 
      if params[:referer]
        redirect_to params[:referer]
      else
        redirect_to :controller => 'cluster', :action => 'index'
      end

    else
      flash[:referer] = params[:referer]
      flash[:login_error] = 'username or password is incorrect!!'
      redirect_to :action => 'index'
    end
  end

  def logout
    reset_session
    $baseHost = nil
    $basePort = nil
    redirect_to '/login/index'
  end

  private
  def redirect_top?
    redirect_to :controller => 'cluster', :action => 'index' if login_check?
  end
end
