module LogsHelper

  def compact_instance(instance)
    instance.scan(/\d/).join("")
  end

  def loglevel_colors(process)
    if process == "INFO"
      color = "info"
    elsif process == "DEBUG"
      color = "default"
    elsif process == "WARN"
      color = "warning"
    elsif process == "ERROR"
      color = "danger"
    end

    color
  end

  def add_00sec(time)
    if time =~ (/^(\d+)-(\d+)-(\d+)T(\d+):(\d+)$/)
      return time << ":00"
    else
      return time
    end
  end
end
