module ApplicationHelper

  def chk_roma_version(vs)
    if /(\d+)\.(\d+)\.(\d+)/ =~ vs
      version = ($1.to_i << 16) + ($2.to_i << 8) + $3.to_i
      return version
    end

    raise
  end

  def memory_mode?(stats_hash)
    if stats_hash['storages[roma]']['storage.st_class'] == "RubyHashStorage"
      return true
    else
      return false
    end
  end

  def groonga_mode?(stats_hash)
    if stats_hash['storages[roma]']['storage.st_class'] == "GroongaStorage"
      return true
    else
      return false
    end
  end

  def storage_type_is_tc?(stats_hash)
    if stats_hash['storages[roma]']['storage.st_class'] == 'TCStorage'
      return true
    else
      return false
    end
  end

  def iso_time_format?(time_string)
    time_string =~ /^(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)$/
  end
 
  def change_iso8601(time)
    if time =~ (/^\d+\/\d+\/\d+\s\d+:\d+$/)
      t = time.gsub("/", "-")
      t = t.sub(/\s/, "T")
      return t << ":00"
    else
      return time
    end
  end
end
