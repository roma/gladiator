$(document).ready(function() {
    $("#dynamic_change_value").validate({
      rules: {
        "size_of_zredundant": {
          required: true,
          digits: true,
          min: 1,
          max: 2147483647
        },
        "hilatency_warn_time": {
          required: true,
          number: true,
          min: 1,
          max: 60
        },
        "spushv_klength_warn": {
          required: true,
          digits: true,
          min: 1,
          max: 2147483647
        },
        "spushv_vlength_warn": {
          required: true,
          digits: true,
          min: 1,
          max: 2147483647
        },
        "routing_trans_timeout": {
          required: true,
          digits: true,
          min: 1,
          max: 86400
        },
        "shift_size": {
          required: true,
          digits: true,
          min: 1,
          max: 2147483647
        },
        "fail_cnt_threshold": {
          required: true,
          digits: true,
          min: 1,
          max: 100
        },
        "fail_cnt_gap": {
          required: true,
          min: 0,
          max: 60
        },
        "sub_nid_netmask": {
          required: true,
          minlength: 9,
          maxlength: 20
        },
        "sub_nid_target": {
          required: true
        },
        "sub_nid_string": {
          required: true
        },
        "continuous_start": {
          required: true,
          digits: true,
          min: 1,
          max: 1000
        },
        "continuous_rate": {
          required: true,
          digits: true,
          min: 1,
          max: 100
        },
        "continuous_full": {
          required: true,
          digits: true,
          min: 1,
          max: 1000
        },
        "accepted_connection_expire_time": {
          required: true,
          digits: true,
          min: 1,
          max: 86400
        },
        "pool_maxlength": {
          required: true,
          digits: true,
          min: 1,
          max: 1000
        },
        "pool_expire_time": {
          required: true,
          digits: true,
          min: 1,
          max: 86400
        },
        "EMpool_maxlength": {
          required: true,
          digits: true,
          min: 1,
          max: 1000
        },
        "EMpool_expire_time": {
          required: true,
          digits: true,
          min: 1,
          max: 86400
        },
        "descriptor_table_size": {
          required: true,
          digits: true,
          min: 1024,
          max: 65535
        }
      }
    });
});
