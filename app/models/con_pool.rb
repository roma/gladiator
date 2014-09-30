require 'socket'
require 'singleton'

class ConPool
  include Singleton

  attr_accessor :maxlength
  attr_accessor :expire_time

  def initialize(maxlength = 3, expire_time = 60)
    @pool = {}
    @maxlength = maxlength
    @expire_time = expire_time
  end

  def get_connection(nid)
    con,last = @pool[nid].shift if @pool.key?(nid) && @pool[nid].length > 0
    if con && last < Time.now - @expire_time
      con.close
      con = nil
    end
    con = create_connection(nid) unless con
    con
  end

  def create_connection(nid)
    addr, port = nid.split(/[:_]/)
    TCPSocket.new(addr, port)
  end

  def return_connection(nid, con)
    if @pool.key?(nid) && @pool[nid].length > 0
      if @pool[nid].length > @maxlength
        con.close
      else
        @pool[nid] << [con, Time.now]
      end
    else
      @pool[nid] = [[con, Time.now]]
    end
  end

  def delete_connection(nid)
    @pool.delete(nid)
  end
end # class ConPool
