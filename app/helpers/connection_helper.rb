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

    return target_log
    #'"Date,High,Low\n"+
    #"2007-01-01 00:00:00,62,9\n"+
    #"2007-01-01 01:00:00,62,38\n"+
    #"2007-01-01 02:00:00,64,7\n"+
    #"2007-01-01 03:00:00,5,7\n"+
    #"2007-01-01 04:00:00,6,35\n"+
    #"2007-01-01 05:00:00,67,3\n"'
  end

  def extract_conn_source(hash)

  end
end
