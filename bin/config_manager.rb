class ConfigManager
  require 'pathname'
  base_path = Pathname(__FILE__).dirname.parent.expand_path
  CONFIG_PATH = "#{base_path}/lib/config_gui.rb"
  CONFIG_ORG_PATH = "#{base_path}/lib/config_gui.rb_org"
  $LOAD_PATH.unshift("#{base_path}/lib")
  require 'config_gui'

  def initialize(org=false)
    @body = ""
    if org
      base_file_path = CONFIG_ORG_PATH
    else
      base_file_path = CONFIG_PATH
      get_current_users
    end
    open(base_file_path, "r") do |f|
      @body = f.read
    end
  end

  def duplicate_check(name)
    @root_user.include?(name) | @normal_user.include?(name)
  end

  def save_user(name, passwd, gravatar, role)
    new_user = "{:username => '#{name}', :password => '#{passwd}', :email => '#{gravatar}' }"
    replace_user(new_user, role)
    write_config
  end

  def brank_check(str)
    while str == '' do
      print "> "
      str = gets.chomp!
    end
    str
  end

  def write_config
    open(CONFIG_PATH, "r+") {|f|
      f.flock(File::LOCK_EX)
      f.puts @body
      f.truncate(f.tell)
    }
  end

  private

  def get_current_users
    @root_user = []
    @normal_user = []
    ConfigGui::ROOT_USER.each{|info|
      @root_user << info[:username]
    }
    ConfigGui::NORMAL_USER.each{|info|
      @normal_user << info[:username]
    }
  end

  def replace_user(new_user, role)
    if role == 'root'
      mode = "ROOT_USER"
    elsif role == 'normal'
      mode = "NORMAL_USER"
    end
    @body =~ /(#{mode} = \[[^\]]*)\]/
    @body.gsub!(/#{mode} = \[[^\]]*\]/, "#{$1}\s\s#{new_user},\n\s\s]")
  end

end # end of class
