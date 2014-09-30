class User
  include ActiveModel::Model

  def initialize(params = nil)
  end

  def self.authenticate(username, password)
    proc = lambda{|user_list|
      if user_info = user_list.find{|user| user[:username] == username && Digest::SHA1.hexdigest(user[:password]) == password }
        return user_info
      end

      return false
    }

    if res = proc.call(ConfigGui::ROOT_USER)
      return [res, 'root']
    end

    if res = proc.call(ConfigGui::NORMAL_USER)
      return [res, 'normal']
    end

    false
  end
end
