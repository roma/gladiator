module LoginHelper

  def get_gravatar_src(email_address = nil)
    hash = Digest::MD5.hexdigest(email_address)
    image_src = "http://www.gravatar.com/avatar/#{hash}?d=mm" # mm is 'mystery-man' image of gravatar
  end

  def chk_roma_version(vs)
    if /(\d+)\.(\d+)\.(\d+)/ =~ vs
      version = ($1.to_i << 16) + ($2.to_i << 8) + $3.to_i
      return version
    end

    raise
  end

end
