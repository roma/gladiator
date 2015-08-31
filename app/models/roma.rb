require 'con_pool'
require 'gladiator_exception'

class Roma
  include ActiveModel::Model

  attr_accessor :dcnice,
    :size_of_zredundant,
    :hilatency_warn_time,
    :spushv_klength_warn,
    :spushv_vlength_warn,
    :routing_trans_timeout,
    :shift_size,
    :fail_cnt_threshold,
    :fail_cnt_gap,
    :sub_nid,
    :lost_action,
    :auto_recover,
    :descriptor_table_size,
    :continuous_limit,
    :accepted_connection_expire_time,
    :pool_maxlength,
    :pool_expire_time,
    :EMpool_maxlength,
    :EMpool_expire_time,
    :dns_caching,
    :key_name,
    :value,
    :expire_time
  attr_reader :stats_hash
  
  validates :dcnice,
    allow_nil: true,
    :length => { :is => 1, :message =>' : You sholud input a priority from 1 to 5.' },
    :numericality => { 
      :only_integer => true,
      :greater_than_or_equal_to => 1,
      :less_than_or_equal_to => 5,
      :message =>' : You sholud input a priority from 1 to 5.' }
  validates :size_of_zredundant, :spushv_klength_warn, :spushv_vlength_warn, :shift_size,
      allow_nil: true,
      :numericality => { 
        :only_integer => true,
        :greater_than_or_equal_to => 1,
        :less_than_or_equal_to => 2147483647,
        :message =>' : number must be from 1 to 2147483647.' }
  validates :hilatency_warn_time,
      allow_nil: true,
      :numericality => { 
        :greater_than_or_equal_to => 1,
        :less_than_or_equal_to => 60,
        :message =>' : number must be from 1 to 60.' }
  validates :routing_trans_timeout, :accepted_connection_expire_time, :pool_expire_time, :EMpool_expire_time,
      allow_nil: true,
      :numericality => { 
        :only_integer => true,
        :greater_than_or_equal_to => 1,
        :less_than_or_equal_to => 86400,
        :message =>' : number must be from 1 to 86400.' }
  validates :fail_cnt_threshold,
      allow_nil: true,
      :numericality => { 
        :only_integer => true,
        :greater_than_or_equal_to => 1,
        :less_than_or_equal_to => 100,
        :message =>' : number must be from 1 to 100.' }
  validates :fail_cnt_gap,
    allow_nil: true,
    :numericality => { 
      :greater_than_or_equal_to => 0,
      :less_than_or_equal_to => 60,
      :message =>' : number must be from 0 to 60.'  }
  validates :pool_maxlength, :EMpool_maxlength,
    allow_nil: true,
    :numericality => { 
      :only_integer => true,
      :greater_than_or_equal_to => 1,
      :less_than_or_equal_to => 1000,
      :message =>' : number must be from 1 to 1000.'  }
  validates :descriptor_table_size,
    allow_nil: true,
    :numericality => { 
      :only_integer => true,
      :greater_than_or_equal_to => 1024,
      :less_than_or_equal_to => 65535,
      :message =>' : number must be from 1024 to 65535.'  }
  validates :continuous_limit,
    allow_nil: true,
    :continuous_limit => true,
    presence: true
  validates :sub_nid,
    allow_nil: true,
    :sub_nid => true,
    presence: true
  validates :key_name, :value,
    allow_nil: true,
    presence: true
  validates :expire_time,
    allow_nil: true,
    :numericality => { 
      :only_integer => true,
      :greater_than_or_equal_to => 0,
      :message =>' : parameter should be digit & over 0'  }

  def initialize(params = nil)
    super(params)
    if $baseHost && $basePort
      @host = $baseHost
      @port = $basePort
    else
      @host = ConfigGui::HOST
      @port = ConfigGui::PORT
    end
  end

  def get_stats(host = @host, port = @port)
    stats_array = send_command('stats', 'END', host, port)

    @stats_hash = Hash.new { |hash,key| hash[key] = Hash.new {} }
    stats_array.each{|a|
      key   = a.split(/\s/)[0].split(".", 2)
      value = a.split(/\s/, 2)[1]
    
      if key.size == 1
        @stats_hash["others"][key[0]] = value
      else key.size == 2
        @stats_hash[key[0]][key[1]] = value
      end
    }
    
    @stats_hash
  end
  
  def check_param(k, v)
    if v.nil?
      errors.add(k, " : This value is required.")
      return false
    elsif ["auto_recover", "dns_caching"].include?(k) && !["false", "true"].include?(v)
      errors.add(k, " : Unexpected Error. This value is required")
      return false
    elsif k == "lost_action" && !["auto_assign", "shutdown"].include?(v)
      errors.add(k, " : Unexpected Error. This value is required")
      return false
    else
      true
    end
  end

  def change_param(k, v)
    res = send_command("#{ApplicationController.helpers.change_cmd(k)} #{v}", nil)

    begin
      res_hash = change_roma_res_style(res)
    rescue
      errors.add(k, "was not updated. Unexpection Error( #{res} ).")
    end

    return res_hash
  end

  def get_all_routing_list
    send_command('get_routing_history')
  end

  def initialize_instance(option_params=nil)
    roma_instance_info = Hash.new { |hash,key| hash[key] = Hash.new {} }

    get_all_routing_list.each{|instance|
      roma_instance_info[instance]["status"] = "inactive"
      roma_instance_info[instance]["size"] = nil
      roma_instance_info[instance]["version"] = nil
      roma_instance_info[instance]["primary_nodes"] = nil
      ##roma_instance_info[instance]["secondary_nodes"] = nil
      #roma_instance_info[instance]["secondary_nodes1"] = nil
      #roma_instance_info[instance]["secondary_nodes2"] = nil
      unless option_params.empty?
        option_params.each{|param|
          roma_instance_info[instance][param] = nil
        }
      end
    }

    roma_instance_info
  end

  def get_routing_info(active_routing_list, *option_params)
    routing_list_info = initialize_instance(option_params)
    active_routing_list.each{|instance|
      begin
        each_stats = self.get_stats(instance.split("_")[0], instance.split("_")[1])

        ### status[active|inactive|recover|join]
        if each_stats["stats"]["run_recover"].chomp == "true"
          status = "recover"
        # for past version
        elsif each_stats["stats"]["run_join"] && each_stats["stats"]["run_join"].chomp == "true"
          status = "join"
        elsif each_stats["stats"]["run_release"].chomp == "true"
          status = "release"
        else
          status = "active"
        end
        routing_list_info[instance]["status"] = status

        ### sum of tc file size of each instance
        size = 0
        10.times{|index|
          size += each_stats["storages[roma]"]["storage[#{index}].fsiz"].to_i
        }
        routing_list_info[instance]["size"] = size
         
        ### version
        routing_list_info[instance]["version"] = each_stats["others"]["version"].chomp

        ### redundancy
        routing_list_info[instance]["redundant"] = rd = each_stats["routing"]["redundant"].to_i
        
        ### vnodes count
        routing_list_info[instance]["primary_nodes"] = each_stats["routing"]["primary"].to_i
        (rd-1).times{|i|
          routing_list_info[instance]["secondary_nodes#{i+1}"] = each_stats["routing"]["secondary#{i+1}"].to_i
        }

        ### option params
        unless option_params.empty?
          option_params.each{|param|
            value = each_stats[ApplicationController.helpers.param_group(param)][param]
            routing_list_info[instance][param] = ApplicationController.helpers.change_param_type(value)
          }
        end
        
      rescue
        routing_list_info[instance]["status"] = "no_response"
      end
    }

    return routing_list_info
  end

  def get_active_routing_list(stats_hash)
    change_roma_res_style(stats_hash["routing"]["nodes"])
  end

  def enabled_repetition_in_routingdump?(host = @host, port = @port)
    res = send_command('enabled_repetition_in_routing?', nil, host, port)
    res.chomp.to_boolean
  end

  def get_routing_dump(format, host = @host, port = @port)
    send_command("routingdump #{format}", "END", host, port)
  end

  def get_value(keyName, host = @host, port = @port)
    send_command("get #{keyName}", "END", host, port)
  end

  def set_value(keyName, value, expt = 0, host = @host, port = @port)
    send_command("set #{keyName} 0 #{expt} #{value.size}\r\n#{value}", nil, host, port)
  end

  def start_gather_logs(line_count, logs_sleep_time ,host, port)
    @logs_sleep_time = logs_sleep_time
    raise "Unexpected type" if line_count.to_s !~ /^[1-9]\d*$/
    send_command("gather_logs #{line_count}", "STARTED", host, port)
  end

  def show_logs(host, port)
    send_command("show_logs", "END", host, port)
  end

  def get_all_logs(active_routing_list)
    active_routing_list.each{|instance|
      self.start_gather_logs(100, 5, instance.split("_")[0], instance.split("_")[1])
    }

    sleep @logs_sleep_time # wait for finishing gathering

    raw_logs = {}
    active_routing_list.each{|instance|
      logs = self.show_logs(instance.split("_")[0], instance.split("_")[1])
      raw_logs.store(instance, logs)
    }

    return raw_logs
  end

  def start_gather_logs_by_date(start_time, end_time, logs_sleep_time ,host, port)
    @logs_sleep_time = logs_sleep_time

    if !ApplicationController.helpers.iso_time_format?(start_time) || !ApplicationController.helpers.iso_time_format?(end_time)
      raise "Unexpected type"
    end

    send_command("gather_logs #{start_time} #{end_time}", "STARTED", host, port)
  end

  def get_all_logs_by_date(active_routing_list, start_time, end_time)
    active_routing_list.each{|instance|
      self.start_gather_logs_by_date(start_time, end_time, 3, instance.split("_")[0], instance.split("_")[1])
    }

    sleep @logs_sleep_time # wait for finishing gathering

    raw_logs = {}
    active_routing_list.each{|instance|
      logs = self.show_logs(instance.split("_")[0], instance.split("_")[1])
      raw_logs.store(instance, logs)
    }

    return raw_logs
  end

  def send_command(command, eof = "END", host = @host, port = @port)
    nid ="#{host}_#{port}"
    con = ConPool.instance.get_connection(nid)
    raise unless con

    con.write("#{command}\r\n")
    if con.eof?
      ConPool.instance.delete_connection(nid)
      raise ConPoolError, "#{host}_#{port}"
    end

    unless eof
      @res = con.gets
    else
      @res = []
      con.each{|s|
        break if s == "#{eof}\r\n"
        @res.push(s.chomp)
        raise "ROMA send back ERROR\r\n#{s.chomp}" if s.chomp =~ /^CLIENT_ERROR|^SERVER_ERROR/
      }
    end

    ConPool.instance.return_connection(nid, con)
    return @res
  end

  # roma_res is response messages from ROMA when some command is executed
  def change_roma_res_style(roma_res)
    case roma_res[0]
    when "{"
      roma_res = roma_res.chomp.gsub(/"|^{|}$/, '')
      roma_res = roma_res.split(/,[\s]*|=>/)
      roma_res.each_with_index{|column, idx|
        roma_res[idx] = column.to_i if column =~ /^\d+$/
      }
      new_style_res = Hash[*roma_res]
    when "["
      roma_res = roma_res.chomp.gsub(/"|^\[|\]$/, '')
      new_style_res = roma_res.split(/,[\s]*/)
    else
      raise "Unexpected style"
    end

    new_style_res
  end

end
