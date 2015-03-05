module ClusterHelper

  def get_active_server_list
    active_server_list = []
    @active_routing_list.each do |active_instance|
      active_instance =~ /^([-\.a-zA-Z\d]+)_/
      active_server_list.push($1)
    end
    active_server_list.uniq
  end

  def main_version
    main_version = @stats_hash["others"]["version"].chomp
  end
  
  def chk_main_version(vs)
    if vs != main_version && vs != nil
      true
    else
      false
    end
  end

  def is_active?(status)
    status !~ /inactive|no_response/
  end

  def short_vnodes?(stats_hash)
    if stats_hash["routing"]["short_vnodes"].chomp == "0"
      return false
    else
      return true
    end
  end

  def lost_vnodes?(stats_hash)
    if stats_hash["routing"]["lost_vnodes"].chomp == "0"
      return false
    else
      return true
    end
  end
  
  def current_size_rate(current_size)
    total_size = 0
    @routing_info.each{|instance, info|
      total_size += info["size"].to_f
    }
    (current_size / total_size * 100).round(1)
  end

  def instance_size(size)
    size / 1024 / 1024
  end

  def get_button_option(command, stats_hash, routing_info, target_instance=nil)
    # for past version
    return "disabled" if command == 'recover' && !can_recover_end?(stats_hash)

    case command
    when "recover"
      return nil if can_i_recover?(stats_hash, routing_info)
    when "release"
      return nil if can_i_release?(stats_hash, routing_info, target_instance)
    when "rbalse"
      return nil if can_i_rbalse?(stats_hash, routing_info, target_instance)
    end

    return "disabled"
  end

  def can_recover_end?(stats_hash)
      if stats_hash['routing']['lost_action'] != 'auto_assign' && chk_roma_version(stats_hash['others']['version']) < 65536 && stats_hash['stats']['enabled_repetition_host_in_routing'] == 'false'
        return false
      end

      return true
  end

  def can_i_recover?(stats_hash, routing_info)
    return false if released_flg?(routing_info)
    return false if flash[:no_response]

    if !short_vnodes?(stats_hash) || extra_process_chk(routing_info) || 
       stats_hash["routing"]["nodes.length"] < stats_hash["routing"]["redundant"]
      return false
    else
      return true
    end
  end

  def can_i_release?(stats_hash, routing_info, target_instance)
    return false if released_flg?(routing_info)
    return false if flash[:no_response]

    if extra_process_chk(routing_info)
      return false
    end

    buf = @active_routing_list.reject{|instance| instance == target_instance }
    receptive_instance = []

    if repetition_host?(stats_hash)  # in case of --enabled_repeathost
      receptive_instance = buf
    else
      buf.each{|instance|
        host = instance.split(/[:_]/)[0]
        receptive_instance << host unless receptive_instance.include?(host)
      }
    end

    return false if receptive_instance.size < stats_hash["routing"]["redundant"].to_i
    return true
  end

  def can_i_rbalse?(stats_hash, routing_info, target_instance)
    if extra_process_chk(routing_info)
      return false
    end

    if released_flg?(routing_info)
      if target_instance != session[:released] 
        return false
      end
    end

    true
  end

  def can_i_use_snapshot?(stats_hash)
    if chk_roma_version(stats_hash['others']['version']) >= 2062
      return true
    else
      return false
    end
  end

  # check "--enabled_repeathost" option is on or off.
  def repetition_host?(stats_hash)
    stats_hash["stats"]["enabled_repetition_host_in_routing"].to_boolean
  end

  def extra_process_chk(routing_info)
    routing_info.values.each{|info|
      return $& if info["status"] =~ /recover|join|release/
    }
    return nil
  end

  def released_flg?(routing_info)
    return true if session[:released]
    routing_info.each{|instance, info|
      if info["primary_nodes"] == 0 && info["secondary_nodes"] == 0
        flash[:error_message] = "Did you execute release? In this case, you have to execute rbalse."
      end
    }

    false
  end

  def param_group(param)
    case param
    when "enabled_repetition_host_in_routing", "gui_run_snapshot"
      "stats"
    when "short_vnodes"
      "routing"
    end
  end

  def change_param_type(param)
    case param
    when /^(true|false)$/
      param = param.to_boolean
    when /^(\d+)$/
      param = param.to_i
    end
    
    param
  end

  def health_btn_color(stats_hash)
    if chk_roma_version(@stats_hash['others']['version']) <= 2059 #v0.8.11
      return 'grey'
    elsif @stats_hash["routing"]["lost_vnodes"].chomp != "0"
      return 'red'
    elsif @stats_hash["routing"]["short_vnodes"].chomp !="0"
      return 'yellow'
    else
      return 'green'
    end 
  end

end
