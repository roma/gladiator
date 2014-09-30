module StatHelper

  def check_skip_columns(column, stats_hash)
    if /^storage\[\d*\]/ =~ column
      return true
    end
    if memory_mode?(stats_hash)
      return true if /storage\.option|storage\.safecopy_stats/ =~ column
    end
  end

  def explanation(column)
    case column
      when "DEFAULT_LOST_ACTION"
        return <<-EOS
          DEFAULT_LOST_ACTION specifies the default action when ROMA loses data by server trouble.<br>
          <br>
          <U>no_action</U>:<br>ROMA denies access to lost data.<br>
          <U>auto_assign</U>:<br>ROMA can access the data as if the lost data never existed.<br>
          <U>shutdown</U>:<br>ROMA will shutdown if the data is lost.
        EOS
      when "LOG_SHIFT_AGE"
        return <<-EOS
       	  Specify number of log files which are rotated. 
        EOS
      when "LOG_SHIFT_SIZE"
        return <<-EOS
          Specify size (in bytes) of the log files.<br>
          When the log file reaches this size, it will rotate to the next file. 
        EOS
      when "LOG_PATH"
        return <<-EOS
          Specify directory that ROMA create log files in.<br>
          The default directory is current directory. 
        EOS
      when "RTTABLE_PATH"
        return <<-EOS
          Specify directory for ROMA to retrieve routing information file.<br>
          Default directory is current directory. 
        EOS
      when "STORAGE_DELMARK_EXPTIME"
        return <<-EOS
          Specify interval (in seconds) in which the deleted value is collected by GC.<br>
          Default is 5 days. 
        EOS
      when "STORAGE_EXCEPTION_ACTION"
        return <<-EOS
          Choose the action which ROMA takes if the storage encounters Exception Error.<br>
          <br>
          <U>no_action</U>: Error instance keep working.<br>
          <U>shutdown</U> : Error instance will be shutdown.
        EOS
      when "DATACOPY_STREAM_COPY_WAIT_PARAM"
        return <<-EOS
          Specify waiting time (in seconds) to copy the data slowly between nodes.
        EOS
      when "PLUGIN_FILES"
        return <<-EOS
          Specify plugin which are read, when ROMA process is started. 	
        EOS
      when "WRITEBEHIND_PATH"
        return <<-EOS
          Specify directory for ROMA to create event log files asynchronously.<br>
          Default directory is "./wb" directory. 
        EOS
      when "WRITEBEHIND_SHIFT_SIZE"
        return <<-EOS
          Specify size (in bytes) of the event log files.<br>
           When log file reaches this size, then log file rotates to the next file.<br>
          Default size is 10MB.
        EOS
      when "CONNECTION_DESCRIPTOR_TABLE_SIZE"
        return <<-EOS
          Specify the maximum number of FileDescriptor when ROMA use epoll system-call(default setting).<br><br>
          This value must be smaller than OS settings.<br><br>
          (You can check FD by use shell command(`ulimit -n`)).
        EOS
      when "config_path"
        return <<-EOS
       	  PATH of configuration file.<br>
          Which is referred when ROMA booting.
        EOS
      when "address"
        return <<-EOS
       	  Address of ROMA server which you refer to
        EOS
      when "port"
        return <<-EOS
       	  Port of ROMA which you refer to
        EOS
      when "daemon"
        return <<-EOS
       	  booting with daemon mode
        EOS
      when "name"
        return <<-EOS
       	  Your ROMA's name.<br>
          Defalut is "ROMA"
        EOS
      when "verbose"
        return <<-EOS
       	  Detail log mode.<br>
          which output many infomation than the debug log mode.
        EOS
      when "enabled_repetition_host_in_routing"
        return <<-EOS
       	  This option allow booting ROMA in only 1server.<br>
          Unless this option, data redundancy keep in multi servers.
        EOS
      when "run_recover"
        return <<-EOS
       	  Recovering process going or not.
        EOS
      when "run_sync_routing"
        return <<-EOS
       	  Sync_routing process going or not.
        EOS
      when "run_iterate_storage"
        return <<-EOS
       	  Iterate_storage process going or not.
        EOS
      when "run_storage_clean_up"
        return <<-EOS
       	  Storage_clean_up process going or not.<br>
          This process execute physical deletion for data which have del flag.
        EOS
      when "run_receive_a_vnode"
        return <<-EOS
       	  Instance is getting vnodes or not.
        EOS
      when "run_release"
        return <<-EOS
       	  Release process is going or not.<br><br>
          This process release the all primary & secondary node.<br><br>
          So after this process, this instance have no data.
        EOS
      when "run_join"
        return <<-EOS
       	  Join process is going or not.
        EOS
      when "run_balance"
        return <<-EOS
       	  Balance process is going or not.
        EOS
      when "last_clean_up"
        return <<-EOS
       	  Date of last executing of clean up storage.
        EOS
      when "last_clean_up"
        return <<-EOS
       	  Date of last executing of clean up storage.
        EOS
      when "spushv_protection"
        return <<-EOS
       	  In case of true, this instance deny the spushv command.<br>
          (pushv process exchange the data between the nodes.<br>
           Ex.) recover, join, release)
        EOS
      when "stream_copy_wait_param"
        return <<-EOS
       	  Specify waiting time (in seconds) to copy the data slowly between nodes.
        EOS
      when "dcnice"
        return <<-EOS
          "dcnice" command is setting priority for a data-copy thread.<br>
          A niceness of 1 is the highest priority and 5 is the lowest priority.<br><br>
       	  <U>when n ==1</U> # highest priority   <br>
            &emsp; stream_copy_wait_param = 0.001  <br>
            &emsp; each_vn_dump_sleep = 0.001      <br>
            &emsp; each_vn_dump_sleep_count = 1000 <br>
                                          <br>
          <U>when n == 2</U>                     <br>
            &emsp; stream_copy_wait_param = 0.005  <br>
            &emsp; each_vn_dump_sleep = 0.005      <br>
            &emsp; each_vn_dump_sleep_count = 100  <br>
                                          <br>
          <U>when n == 3</U> # default priority  <br>
            &emsp; stream_copy_wait_param = 0.01   <br>
            &emsp; each_vn_dump_sleep = 0.001      <br>
            &emsp; each_vn_dump_sleep_count = 10   <br>
                                          <br>
          <U>when n == 4</U>                     <br>
            &emsp; stream_copy_wait_param = 0.01   <br>
            &emsp; each_vn_dump_sleep = 0.005      <br>
            &emsp; each_vn_dump_sleep_count = 10   <br>
                                          <br>
          <U>when n == 5</U> # lowest priority   <br> 
            &emsp; stream_copy_wait_param = 0.01   <br>
            &emsp; each_vn_dump_sleep = 0.01       <br>
            &emsp; each_vn_dump_sleep_count = 10
        EOS
      when "clean_up_interval"
        return <<-EOS
          Specify the time(sec) interval to execute cleanup.<br>
          Cleanup process delete the data which have del flg.
        EOS
      when "size_of_zredundant"
        return <<-EOS
          Specify the maximum size (in bytes) of data.<br>
          While data is forwarded to other nodes for redundancy, data that exceed this size will be compressed before forwarding.<br>
          Default data size is 0.<br>
          If the value is 0 then the data will not be compressed. 
        EOS
      when "write_count"
        return <<-EOS
       	  Total write count of this instance.
        EOS
      when "read_count"
        return <<-EOS
       	  Total read count of this instance.
        EOS
      when "delete_count"
        return <<-EOS
       	  Total delete count(logical delete) of this instance.
        EOS
      when "out_count"
        return <<-EOS
       	  Total delete count(physical delete) of this instance as a primary node.<br>
        EOS
      when "out_message_count"
        return <<-EOS
       	  Total delete count(physical delete) of this instance as a secondary node.<br>
        EOS
      when "redundant_count"
        return <<-EOS
       	  Count of getting [rset|rzset] command.<br><br>
          These command send from primary node's instance to secondary node's instance.         
        EOS
      when "hilatency_warn_time"
        return <<-EOS
          Specify time (in seconds) to which decide the normal limit of executing time of command.<br><br>
       	  if some operation take time over this setting second, error log will be output.
        EOS
      when "wb_command_map"
        return <<-EOS
       	  Target command list of write-behind func.<br>
          Ex.)<br>
          &emsp; {:get=>1, :set=>2}
        EOS
      when "latency_log"
        return <<-EOS
       	  Latency checking is working or not.
        EOS
      when "latency_check_cmd"
        return <<-EOS
       	  Target command of latency checking.
        EOS
      when "latency_check_time_count"
        return <<-EOS
          Specify the interval to calculate the latency average.
        EOS
      when "spushv_klength_warn"
        return <<-EOS
          Specify the limit size of key length.<br>
       	  When target key size over the this setting, warning log will be output.<br>
          During the vnode copy.(ex.recover, join)
        EOS
      when "spushv_vlength_warn"
        return <<-EOS
          Specify the limit size of value length.<br>
       	  When target value size over the this setting, warning log will be output.<br>
          During the vnode copy.(ex.recover, join)
        EOS
      when "spushv_read_timeout"
        return <<-EOS
       	  Specify the coefficient of Timeout time by using spushv command.<br>
          Timeout time = (handler.timeout * spushv_read_timeout)<br>
          Defalut timeout time is 1000(sec).<br>
          10 * 100 = 1000
        EOS
      when "reqpushv_timeout_count"
        return <<-EOS
       	  Specify the coefficient of Timeout time of getting vnode.<br><br>
          Next request send when last request is finished or this timeout time is elasped.<br><br>
          Timeout time is (0.1 * reqpushv_timeout_count).<br><br>
          (pushv process exchange the data between the nodes.<br>
           Ex.) recover, join, release)
        EOS
      when "routing_trans_timeout"
        return <<-EOS
       	  Specify the transaction time of routing change.<br>
          When over the this setting time, routing will be rollback.
        EOS
      when "storage.storage_path"
        return <<-EOS
       	  Specify directory that ROMA should create storage files in.<br><br>
          This is required when ROMA select file-based storage implementation.<br>
          Default directory is current directory.
        EOS
      when "storage.divnum"
        return <<-EOS
       	  Specify the number which divides the storage of ROMA process.
        EOS
      when "storage.option"
        return <<-EOS
       	  <U>bnum</U>   : <br>
                          count of keys which locate in first line of tc file.<br>
                          Basically not change.<br>
                          <br>
          <U>xmsiz</U>  : <br> 
                          rate of memory using in each tc files.<br>
                          If data size over this value, disk access will occure.<br>
                          <br>
          <U>opts</U>   : <br>
                          l => Support large file(over the 2GB)<br>
                          d => bzip compression. it decrease tc files amount.<br>
                          <br>
          <U>dfunit</U> : <br>
                          Unit of defrag. Basically not change.
        EOS
      when "storage.each_vn_dump_sleep"
        return <<-EOS
          When vnode_dump operation, non-target vnodes were skipped.<br>
          But at this time, skipping with no-sleep time triggers increasing stress of storage access.<br>
          On the other hand, skipping with sleep each time triggers increasing stress of process.<br><br>
       	  So ROMA specify the time of sleeping during v-nodes dump operations by use this setting.
        EOS
      when "storage.each_vn_dump_sleep_count"
        return <<-EOS
          When vnode_dump operation, non-target vnodes were skipped.<br>
          But at this time, skipping with no-sleep time triggers increasing stress of storage access.<br>
          On the other hand, skipping with sleep each time triggers increasing stress of process.<br><br>
       	  So ROMA specify the interval of executing sleeping during v-nodes dump operation by use this setting.
        EOS
      when "storage.each_clean_up_sleep"
        return <<-EOS
       	  Specify the time of sleeping in each keys when clean up executing.<br><br>
       	  So at least, clean_up process take time over ([storage.each_clean_up_sleep] * Key count)sec
        EOS
      when "storage.logic_clock_expire"
        return <<-EOS
          ROMA's data have date data & logic clock.<br><br>
          But sometimes some difference happen between date data & logic clock.<br><br>
          This setting specify the time lag to estimate which node's data is correct.
        EOS
      when "path"
        return <<-EOS
       	  Path of write-behind's file
        EOS
      when "shift_size"
        return <<-EOS
          specify size (in bytes) of the log files.<br>
          When the log file reaches this size, it will rotate to the next file.
        EOS
      when "do_write"
        return <<-EOS
          Write-Behind func is working or not.<br><br>
          Write-behind function keep history of target command.<br>
          Ex.) Excecuting time, value, etc...
        EOS
      when "redundant"
        return <<-EOS
       	  Count of redundancy.
        EOS
      when "nodes.length"
        return <<-EOS
       	  Counts of nodes.
        EOS
      when "nodes"
        return <<-EOS
       	  Node list of ROMA.
        EOS
      when "dgst_bits"
        return <<-EOS
       	  Counts of digest bits.<br><br>
          Each node have unique hash value(SHA1).<br>
          Basically SHA1 generate 160bit digest.<br><br>
          But it is difficult to use it by client soft which were developed by C or Java.<br><br>
          So ROMA can decrease digest bit count by use this setting.<br>
          Default is 32bits.
        EOS
      when "div_bits"
        return <<-EOS
          Specify the count of vnodes.<br>
       	  vnodes count = (2**x)
        EOS
      when "vnodes.length"
        return <<-EOS
       	  Count of the vnodes.
        EOS
      when "primary"
        return <<-EOS
       	  Count of the primary node which this instance have.
        EOS
      when "secondary"
        return <<-EOS
       	  Count of the secondary node which this instance have.
        EOS
      when "short_vnodes"
        return <<-EOS
       	  Count of short vnodes.<br>
       	  Short vnodes is the node which break the redundancy.<br>
          So this value should be 0 in general.
        EOS
      when "lost_vnodes"
        return <<-EOS
       	  Count of lost nodes.<br>
          This node's data was lost and ROMA can't access.<br>
          So this value should be 0 in general.
        EOS
      when "fail_cnt_threshold"
        return <<-EOS
       	  Counts for judge fail-over.<br><br>
          When ROMA fails to health check continuously of this setting count, ROMA will execute failover.
        EOS
      when "fail_cnt_gap"
        return <<-EOS
       	  Specify time (in seconds).<br><br>
          When ROMA can't get the routing information while ROUTING_FAIL_CNT_GAP time elapse, ROMA counts up a counter for fail-over.
        EOS
      when "sub_nid"
        return <<-EOS
       	  ROMA can convert own routing temporarily.<br>
          This value is the conversion pattern of routing.<br>
          <U>Pattern is below</U><br>
          &emsp;&emsp;        {"Target Net Mask"=>{<br>
          &emsp;&emsp;&emsp;    :regexp=>"substitution target IP",<br>
          &emsp;&emsp;&emsp;    :replace=>"substitution pattern"<br>
          &emsp;&emsp;        }}<br><br>

          Ex.)<br>
          &emsp;&emsp;        {"127.0.0.0/24"=>{<br>
          &emsp;&emsp;&emsp;    :regexp=>"127.0.0.1",<br>
          &emsp;&emsp;&emsp;    :replace=>"127.0.0.2"<br>
          &emsp;&emsp;        }}
        EOS
      when "lost_action"
        return <<-EOS
       	  DEFAULT_LOST_ACTION specifies the default action when ROMA loses data by server trouble. <br>
          <br>
          <U>no_action</U>  : ROMA denies access to lost data.<br>
          <U>auto_assign</U>: ROMA can access the data as if the lost data never existed. <br>
          <U>shutdown</U>   : ROMA will shutdown if the data is lost.
        EOS
      when "auto_recover"
        return <<-EOS
       	  In case of true, ROMA will execute recover when short vnodes rise.
        EOS
      when "auto_recover_time"
        return <<-EOS
       	  Specify the waiting time to execute auto-recover after short vnode rising.
        EOS
      when "auto_recover_status"
        return <<-EOS
       	  <U>waiting</U>   : Nothing to do (Default) <br>
          <U>preparing</U> : prepare for execute recover(relate to auto_recover_time)<br>
          <U>executing</U> : executing recover
        EOS
      when "version_of_nodes"
        return <<-EOS
       	  ROMA version of each nodes.<br><br>
          In case of all number are same, all instance use same version of ROMA.<br><br>
          Otherwise some instance use wrong version.<br>
        EOS
      when "min_version"
        return <<-EOS
       	  Oldest version of instance in ROMA cluster.
        EOS
      when "count"
        return <<-EOS
       	  Connection counts of Eventmachine.
        EOS
      when "descriptor_table_size"
        return <<-EOS
       	  Specify the maximum number of FD(File descriptor).<br>
          <br>
          This param is required when ROMA use epoll system-call.<br>
          (You can check ROMA use epoll system or not by the "CONNECTION_USE_EPOLL")<br>
          <br>
          This value must be smaller than OS settings.
        EOS
      when "continuous_limit"
        return <<-EOS
       	  Specify the upper limit of connections.<br>
          Specify the three colon separated values ''start:rate:full''<br>
          (Ex. '200(conns):30(%):300(conns)).<br>
          <br>
          <U>start</U>:<br>
            ROMA will disconnect unused connection with a probability of ''rate/100'',
                   when connection reach this value.<br>
          <br>
          <U>full</U>:<br>
            If the number of using connections reaches "full", ROMA will disconnect unused connections with a probability of 100%.<br>
        EOS
      when "accepted_connection_expire_time"
        return <<-EOS
       	  Specify time(in seconds).<br>
          <br>
          When a connection which ROMA received isn't used while CONNECTION_EXPTIME seconds, ROMA will disconnect this connection.<br>
          <br>
          If the value is 0, then ROMA will not disconnect.<br>
        EOS
      when "handler_instance_count"
        return <<-EOS
       	  Current connection counts.
        EOS
      when "pool_maxlength"
        return <<-EOS
          Specify the maximum number of connections which the connection pool of asynchronous connection keeps.<br>
        EOS
      when "pool_expire_time"
        return <<-EOS
          Specify time(in seconds).<br>
          When ROMA uses a connection pool of asynchronous connection,<br> 
          <br>
          ROMA will disconnect the connection which isn't used while CONNECTION_POOL_EXPTIME seconds after the connection is returned to the pool.<br>
          <br>
          This parameter should be smaller than CONNECTION_EXPTIME parameter.
        EOS
      when "EMpool_maxlength"
        return <<-EOS
          Specify the maximum number of EventMachine's connections which the connection pool of synchronous connection keeps.<br>
          <br>
          The amount of synchronous connection depends on the traffic of client accesses.<br>
          <br>
          The recommended value is approximately-same as the number of ROMA client pool settings, as a rough guide 10 to 15.<br>
          (EM is EventMachine)       
        EOS
      when "EMpool_expire_time"
        return <<-EOS
          Specify time(in seconds).<br>
          When ROMA uses a connection pool of synchronous connection,<br>
          <br>
          ROMA will disconnect the connection which isn't used while CONNECTION_EMPOOL_EXPTIME seconds after the connection is returned to the pool.<br>
          <br>
          The parameter should be smaller than CONNECTION_EXPTIME parameter.<br>
          (EM is EventMachine)       
        EOS
      when "version"
        return <<-EOS
       	  ROMA's version
        EOS
      when "dns_caching"
        return <<-EOS
          dns caching func is going or not.
       	  dns info keep in each instance as a cache.
        EOS
    end
  end

  def default_value(column)
    case column
      #when "stream_copy_wait_param"
      #  Constants::DEFAULT_STREAM_COPY_WAIT_PARAM
      when "dcnice"
        Constants::DEFAULT_DCNICE
      when "size_of_zredundant"
        Constants::DEFAULT_ZREDUNDANT
      when "hilatency_warn_time"
        Constants::DEFAULT_HILATENCY_WARN_TIME
      #when "wb_command_map"
      #  Constants::DEFAULT_WB_COMMAND_MAP
      #when "latency_log"
      #  Constants::DEFAULT_LATENCY_LOG
      #when "latency_check_cmd"
      #  Constants::DEFAULT_LATENCY_CHECK_CMD
      #when "latency_check_time_count"
      #  Constants::DEFAULT_LATENCY_CHECK_TIME_COUNT
      when "spushv_klength_warn"
        Constants::DEFAULT_SPUSHV_KLENGTH_WARN
      when "spushv_vlength_warn"
        Constants::DEFAULT_SPUSHV_VLENGTH_WARN
      when "routing_trans_timeout"
        Constants::DEFAULT_ROUTING_TRNAS_TIMEOUT
      when "shift_size"
        Constants::DEFAULT_SHIFT_SIZE
      #when "do_write"
      #  Constants::DEFAULT_DO_WRITE
      when "fail_cnt_threshold"
        Constants::DEFAULT_FAIL_CNT_THRESHOLD 
      when "fail_cnt_gap"
        Constants::DEFAULT_FAIL_CNT_GAP
      when "sub_nid"
        Constants::DEFAULT_SUB_NID
      when "lost_action"
        Constants::DEFAULT_LOST_ACTION
      when "auto_recover"
        Constants::DEFAULT_AUTO_RECOVER
      #when "auto_recover_time"
      #  Constants::DEFAULT_AUTO_RECOVER_TIME
      when "continuous_limit"
        Constants::DEFAULT_CONTINUOUS_LIMIT
      when "accepted_connection_expire_time"
        Constants::DEFAULT_ACCEPTED_CONNECTION_EXPIRE_TIME
      when "pool_maxlength"
        Constants::DEFAULT_POOL_MAXLENGTH
      when "pool_expire_time"
        Constants::DEFAULT_POOL_EXPIRE_TIME
      when "EMpool_maxlength"
        Constants::DEFAULT_EMPOOL_MAXLENGTH
      when "EMpool_expire_time"
        Constants::DEFAULT_EMPOOL_EXPIRE_TIME
      when "descriptor_table_size"
        Constants::DEFAULT_DESCRIPTOR_TABLE_SIZE
      when "dns_caching"
        Constants::DEFAULT_DNS_CACHING
    end
  end

  def change_list(key)
    case key
      when "lost_action"
        Constants::LIST_LOST_ACTION
      when "dcnice"
        Constants::LIST_DCNICE_VALUE
      when "auto_recover"
        Constants::LIST_AUTO_RECOVER
      when "dns_caching"
        Constants::LIST_DNS_CACHING
      when "continuous_limit"
        Constants::LIST_CONTINUOUS_LIMIT
      when "sub_nid"
        Constants::LIST_SUB_NID
      #when "latency_log"
      #  Constants::LIST_LATENCY_LOG
      #when "latency_check_cmd"
      #  Constants::LIST_LATENCY_CHECK_CMD
      #when "latency_check_time_count"
      #  Constants::LIST_LATENCY_CHECK_TIME_COUNT
      #when "do_write"
      #  Constants::LIST_DO_WRITE
      #when "wb_command_map"
      #  Constants::LIST_WB_COMMAND_MAP
    end
  end

  def change_cmd(key)
    case key
      #when "stream_copy_wait_param"
      #  ""
      when "dcnice"
        "dcnice"
      when "size_of_zredundant"
        "set_size_of_zredundant"
      when "hilatency_warn_time"
        "set_hilatency_warn_time"
      #when "wb_command_map"
      #  {}
      #when "latency_log"
      #  false
      #when "latency_check_cmd"
      #  ["get", "set", "delete"]
      #when "latency_check_time_count"
      #  false
      when "spushv_klength_warn"
        "set_spushv_klength_warn"
      when "spushv_vlength_warn"
        "set_spushv_vlength_warn"
      when "routing_trans_timeout"
        "set_routing_trans_timeout"
      when "shift_size"
        "set_wb_shift_size"
      #when "do_write"
      #  false
      when "fail_cnt_threshold"
        "set_threshold_for_failover"
      when "fail_cnt_gap"
        "set_gap_for_failover"
      when "sub_nid"
        "add_rttable_sub_nid"
      when "lost_action"
        "set_lost_action"
      when "auto_recover"
        "set_auto_recover"
      #when "auto_recover_time"
      #  "set_auto_recover"
      when "continuous_limit"
        "set_continuous_limit"
      when "accepted_connection_expire_time"
        "set_accepted_connection_expire_time"
      when "pool_maxlength"
        "set_connection_pool_maxlength"
      when "pool_expire_time"
        "set_connection_pool_expire_time"
      when "EMpool_maxlength"
        "set_emconnection_pool_maxlength"
      when "EMpool_expire_time"
        "set_emconnection_pool_expire_time"
      when "descriptor_table_size"
        "set_descriptor_table_size"
      when "dns_caching"
        "switch_dns_caching"
    end
  end

end # End of module
