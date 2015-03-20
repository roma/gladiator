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

end
