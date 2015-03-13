module ConnectionHelper
  def extract_conn_count(hash)
    target_log = {}
    hash.each{|instance, logs|
      target_log[instance] = {}
      logs.each{|log|
        #if log =~ /^I, \[[-\dT:.]+\s#\d+\]\sINFO -- : Connected from [\d.:]+\sI have (\d+) connections.$/
        if log =~ /^I, \[([-\d]+)T([\d:]+)\.\d+\s#\d+\]\s+INFO -- : Connected from [\d.:]+\sI have (\d+) connections.$/
          target_log[instance].store("#{$1} #{$2}", $3)
        end
      }
    }

    m_array = merge_connection_count(target_log)

    m_array.each_with_index{|array, index|
      m_array[index] = "#{array.join(",")}\n"
    }

    return m_array

  end

  def debug
    "
      2007-01-01 00:00:00,62,9
      2007-01-01 04:00:00,6,35
      2007-01-01 03:00:00,5,
      2007-01-01 02:00:00,64,7
      2007-01-01 01:00:00,,38
      2007-01-01 05:00:00,67,3
    "
    #'"2007-01-01 00:00:00,62,9\n"+
    #"2007-01-01 04:00:00,6,35\n"+
    #"2007-01-01 03:00:00,5,\n"+
    #"2007-01-01 02:00:00,64,7\n"+
    #"2007-01-01 01:00:00,,38\n"+
    #"2007-01-01 05:00:00,67,3\n"'
  end

  def extract_conn_source(hash)

  end

  private
  def merge_connection_count(hash)
    merged_count_data = Hash.new()
    hash.each_with_index{|(instance, logs), index|
      logs.each{|time, conn_cnt|
        merged_count_data.store(time, Array.new(hash.size, "null")) unless merged_count_data.has_key?(time)
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
