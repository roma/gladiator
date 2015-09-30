module ApplicationHelper

  def chk_roma_version(vs)
    if /(\d+)\.(\d+)\.(\d+)/ =~ vs
      version = ($1.to_i << 16) + ($2.to_i << 8) + $3.to_i
      return version
    end

    raise
  end

  def storage_type_is_tc?(stats_hash)
    # for v1.0.0
    if chk_roma_version(stats_hash['others']['version']) == Constants::VERSION_1_0_0 && @stats_hash['storages[roma]']['storage[0].fsiz']
      return true
    end

    # for v1.1.0-
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
