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
      m_array[index] = "#{array.join(",")}"
    }

    return m_array.join("\n")

  end

  def debug
"
2015-03-13 08:19:07,3,3,3 
2015-03-13 08:19:12,4,null,null 
2015-03-13 08:19:15,5,4,4 
2015-03-13 08:29:07,6,null,null 
2015-03-13 08:32:35,6,null,null 
2015-03-13 08:35:21,6,null,null 
2015-03-13 08:37:56,6,null,null 
2015-03-13 08:41:09,6,6,5 
2015-03-13 08:42:47,6,6,5 
2015-03-13 08:48:47,6,7,6 
2015-03-13 08:50:56,6,7,6 
2015-03-13 08:53:46,6,7,6 
2015-03-13 08:57:06,6,7,6 
2015-03-13 09:04:34,6,7,6 
2015-03-13 09:05:47,6,7,6 
2015-03-13 09:08:23,6,7,6 
2015-03-13 09:12:08,6,6,6 
2015-03-13 09:16:11,6,null,null 
2015-03-13 09:18:22,6,null,null 
2015-03-13 09:22:46,6,null,null 
2015-03-13 09:26:02,6,null,null 
2015-03-13 09:28:12,6,null,null 
2015-03-13 09:30:37,6,6,6 
2015-03-13 09:35:05,6,null,null 
2015-03-13 09:37:44,6,null,null 
2015-03-13 09:40:40,6,6,6 
2015-03-13 09:46:52,6,7,6 
2015-03-13 09:53:30,6,7,6 
2015-03-13 10:01:23,6,null,null 
2015-03-13 08:19:02,null,2,2 
2015-03-13 08:19:17,null,5,5 
2015-03-13 08:19:39,null,6,null 
2015-03-13 08:35:22,null,6,5 
2015-03-13 08:37:57,null,6,5 
2015-03-13 08:42:52,null,7,6 
2015-03-13 09:23:00,null,6,6 
2015-03-13 09:26:03,null,6,6 
2015-03-13 09:28:13,null,6,6 
2015-03-13 09:35:08,null,6,6 
2015-03-13 09:37:45,null,6,6 
2015-03-13 09:42:08,null,7,null 
2015-03-13 09:43:31,null,7,6 
2015-03-13 09:49:29,null,7,6 
"

    #"
    #  2007-01-01 00:00:00,62,9
    #  2007-01-01 04:00:00,6,35
    #  2007-01-01 03:00:00,5,
    #  2007-01-01 02:00:00,64,7
    #  2007-01-01 01:00:00,,38
    #  2007-01-01 05:00:00,67,3
    #"
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
