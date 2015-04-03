# coding: utf-8

module Constants
  private
  # version
  VERSION = "1.1.0"

  # ROMA bit shifted version
  VERSION_0_8_11 = 2059
  VERSION_0_8_12 = 2060
  VERSION_0_8_13 = 2061
  VERSION_0_8_14 = 2062
  VERSION_1_0_0  = 65536
  VERSION_1_1_0  = 65792

  # stats colomn name
  STATS_COL_NAME = ["config","stats","storages[roma]","write-behind","routing","connection","others"]

  # default value
  DEFAULT_STREAM_COPY_WAIT_PARAM          = 0.001
  DEFAULT_DCNICE                          = 3
  DEFAULT_ZREDUNDANT                      = 0
  DEFAULT_HILATENCY_WARN_TIME             = 5.0
  DEFAULT_WB_COMMAND_MAP                  = {}
  DEFAULT_LATENCY_LOG                     = false
  DEFAULT_LATENCY_CHECK_CMD               = ["get", "set", "delete"]
  DEFAULT_LATENCY_CHECK_TIME_COUNT        = false
  DEFAULT_SPUSHV_KLENGTH_WARN             = 1024
  DEFAULT_SPUSHV_VLENGTH_WARN             = 1048576
  DEFAULT_ROUTING_TRNAS_TIMEOUT           = 10080
  DEFAULT_LOG_SHIFT_SIZE                  = 1024 * 1024 * 10
  DEFAULT_LOG_SHIFT_AGE                   = 10
  DEFAULT_SHIFT_SIZE                      = 1024 * 1024 * 10
  DEFAULT_DO_WRITE                        = false
  DEFAULT_FAIL_CNT_THRESHOLD              = 15
  DEFAULT_FAIL_CNT_GAP                    = 0
  DEFAULT_SUB_NID                         = {}
  DEFAULT_LOST_ACTION                     = ":auto_assign"
  DEFAULT_AUTO_RECOVER                    = false
  DEFAULT_AUTO_RECOVER_TIME               = 1800
  DEFAULT_CONTINUOUS_LIMIT                = "200:30:300"
  DEFAULT_ACCEPTED_CONNECTION_EXPIRE_TIME = 0
  DEFAULT_POOL_MAXLENGTH                  = 5
  DEFAULT_POOL_EXPIRE_TIME                = 30
  DEFAULT_EMPOOL_MAXLENGTH                = 15
  DEFAULT_EMPOOL_EXPIRE_TIME              = 30
  DEFAULT_DESCRIPTOR_TABLE_SIZE           = 4096
  DEFAULT_DNS_CACHING                     = false
  
  # change value list
  LIST_LOST_ACTION                     = ["auto_assign", "shutdown"]
  LIST_DCNICE_VALUE                    = [1,2,3,4,5]
  LIST_AUTO_RECOVER                    = [true, false]
  LIST_DNS_CACHING                     = [true, false]
  LIST_CONTINUOUS_LIMIT                = "200:30:300"
  LIST_SUB_NID                         = {}
  LIST_LATENCY_LOG                     = false
  LIST_LATENCY_CHECK_CMD               = ["get", "set", "delete"]
  LIST_LATENCY_CHECK_TIME_COUNT        = false
  LIST_DO_WRITE                        = false
  LIST_WB_COMMAND_MAP                  = {}
  

end
