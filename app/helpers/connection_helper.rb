module ConnectionHelper
  def extract_conn_count(hash)
    target_log = {}
    hash.each{|instance, logs|
      target_log[instance] = {}
      logs.each{|log|
        if log =~ /^I, \[([-\d]+)T([\d:]+)\.\d+\s#\d+\]\s+INFO -- : Connected from [\d.:]+\sI have (\d+) connections.$/
          target_log[instance].store("#{$1} #{$2}", $3)
        end
      }
    }
    m_array = merge_connection_count(target_log)
    m_array.each_with_index{|array, index|
      m_array[index] = "#{array.join(",")}"
    }

    return m_array.join("\n") #csv
  end

  def extract_conn_source(hash)
    target_log = {}
    hash.each{|instance, logs|
      logs.each{|log|
        if log =~ /^I, \[[-\d]+T[\d:]+\.\d+\s#\d+\]\s+INFO -- : Connected from ([\d.]+):[\d.]+\sI have \d+ connections.$/
          if target_log.has_key?($1)
            target_log[$1] += 1
          else
            target_log[$1] = 1
          end
        end
      }
    }

    return target_log #array
  end

  private
  def merge_connection_count(hash)
    merged_count_data = Hash.new()
    hash.each_with_index{|(instance, logs), index|
      logs.each{|time, conn_cnt|
        merged_count_data.store(time, Array.new(hash.size)) unless merged_count_data.has_key?(time)
        merged_count_data[time][index] = conn_cnt
      }
    }

    merged_count_data = merged_count_data.to_a
    merged_count_data.each{|data|
      data.flatten!
    }

    return merged_count_data
  end
end
