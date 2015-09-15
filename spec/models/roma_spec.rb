#require 'spec_helper'
require_relative 'basic_spec'

puts "[Model test(roma_spec.rb)]"

begin
  roma = Roma.new
  env = roma.get_stats
  raise if env["stats"]["enabled_repetition_host_in_routing"].chomp != "true"
  raise if env["routing"]["nodes.length"].to_i < 2

  active_routing_list_env = roma.change_roma_res_style(env["routing"]["nodes"])
  routing_info_env  = roma.get_routing_info(active_routing_list_env)
  routing_info_env.each{|instance, info|
    raise if info["status"] != "active"
  }

  
rescue
  prepare = <<-'EOS'
  [ROMA condition Error] 
    This test require the below conditions.
    If this error message was displayed, please check your ROMA status.
      1. ROMA is booting
      2. No instance is down
      3. instance count should be over 2
      4. enabled_repetition_host_in_routing is true(--enabled_repeathost)
  EOS
  puts prepare
  exit!
end


describe Roma do
#[Status check](ph1)=================================================================
  describe "phase1" do
    context "stats_result" do
      res = Roma.new.get_stats

      it "[1-1]" do expect(res).to be_a_kind_of(Hash) end # Hash or Not
      it "[1-2]stats_hash have 7 parent column " do
        ## Config, Stats, Storage[roma], Write-behind, Routing, Connection, others
        expect(res.size).to be 7
      end
      
      it "[1-3]check all param have value(not have nil)" do
        res.each{|k1, v1|
          v1.each{|k2, v2|
            expect(res[k1][k2]).not_to be_nil
          }
        }
      end
    end
  end

#[Dynamic command check](ph2)=================================================================
  describe "phase2" do
    columns = {
      "stats" => [
        "size_of_zredundant",
        "hilatency_warn_time",
        "spushv_klength_warn",
        "spushv_vlength_warn",
        "routing_trans_timeout",
        "log_shift_age"
      ],
      "write-behind" => [
        "shift_size"
      ],
      "routing" => [
        "fail_cnt_threshold",
        "fail_cnt_gap",
        "auto_recover",
        "enabled_failover"
      ],
      "connection" => [
        "accepted_connection_expire_time",
        "pool_maxlength",
        "pool_expire_time",
        "EMpool_maxlength",
        "EMpool_expire_time"
      ],
      "others" => [
        "dns_caching"
      ]
    }

    columns.each{|group, column_ary|
      column_ary.each{|column|
        #context "dynamic_command_validation_normal", :focus => true do
        context "dynamic_command_check[#{column}]=====================================" do
          if column == "dns_caching" || column == "auto_recover"
            it_should_behave_like 'dynamic cmd check', column, "true", group, "boolean"
            it_should_behave_like 'validation check', column, "true",     "normal"
            it_should_behave_like 'validation check', column, "false",    "normal"
            it_should_behave_like 'validation check', column, "on",       "Unexpected"
            it_should_behave_like 'validation check', column, "hogehoge", "Character"
            it_should_behave_like 'validation check', column, nil,        "nil"
          elsif column == "enabled_failover" 
            it_should_behave_like 'dynamic cmd check', column, "on", group, "boolean"
            it_should_behave_like 'validation check', column, "on",       "normal"
            it_should_behave_like 'validation check', column, "off",      "normal"
            it_should_behave_like 'validation check', column, "true",     "Unexpected"
            it_should_behave_like 'validation check', column, "hogehoge", "Character"
            it_should_behave_like 'validation check', column, nil,        "nil"
          else
            #if column == "hilatency_warn_time" || column == "fail_cnt_gap" || column == "routing_trans_timeout"
            if column == "hilatency_warn_time" || column == "routing_trans_timeout"
              it_should_behave_like 'dynamic cmd check', column, "40.0", group, "string"
            elsif column == "fail_cnt_gap"
              it_should_behave_like 'dynamic cmd check', column, "1.0", group, "string"
            elsif column == "fail_cnt_threshold"
              it_should_behave_like 'dynamic cmd check', column, "5", group, "string"
            else
              it_should_behave_like 'dynamic cmd check', column, "40", group, "string"
            end
            it_should_behave_like 'validation check', column, 50,         "normal"
            it_should_behave_like 'validation check', column, -50,        "under0"
            it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
            it_should_behave_like 'validation check', column, "hogehoge", "Character"
            it_should_behave_like 'validation check', column, nil,        "nil"
          end
        end
      }
    }

    specific_columns = {
      "stats" => [
        "dcnice",
        "log_shift_size"
      ],
      "connection" => [
        "descriptor_table_size",
        "continuous_limit"
      ],
      "routing" => [
        "sub_nid",
        "lost_action"
      ]
    }

    specific_columns.each{|group, column_ary|
      column_ary.each{|column|
        #context "dynamic_command_validation_normal", :focus => true do
        context "dynamic_command_check(specific columns)[#{column}]=====================================" do
          if column == "dcnice"
            it_should_behave_like 'dynamic cmd check', column, "4", group, "string"
            it_should_behave_like 'validation check', column, 5,          "normal"
            it_should_behave_like 'validation check', column, 10,         "Over Length"
            it_should_behave_like 'validation check', column, -50,        "under0"
            it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
            it_should_behave_like 'validation check', column, "hogehoge", "Character"
            it_should_behave_like 'validation check', column, nil,        "nil"
          elsif column == "log_shift_size"
            it_should_behave_like 'dynamic cmd check', column, "4096", group, "string"
            it_should_behave_like 'validation check', column, 4096,       "normal"
            it_should_behave_like 'validation check', column, -50,        "under0"
            it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
            it_should_behave_like 'validation check', column, "hogehoge", "Character"
            it_should_behave_like 'validation check', column, nil,        "nil"
          elsif column == "descriptor_table_size"
            it_should_behave_like 'dynamic cmd check', column, "2048", group, "string"
            it_should_behave_like 'validation check', column, 4096,       "normal"
            it_should_behave_like 'validation check', column, -50,        "under0"
            it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
            it_should_behave_like 'validation check', column, "hogehoge", "Character"
            it_should_behave_like 'validation check', column, nil,        "nil"
          elsif column == "continuous_limit"
            it_should_behave_like 'dynamic cmd check', column, "600:80:800", group, "string"
            it_should_behave_like 'validation check', column, "500:60:700",  "normal"
            it_should_behave_like 'validation check', column, "-500:60:700", "under0", "con1" 
            it_should_behave_like 'validation check', column, "500:-60:700", "under0", "con2"
            it_should_behave_like 'validation check', column, "500:60:-700", "under0", "con3"
            it_should_behave_like 'validation check', column, "5000:60:700", "Over Limit", "con1"
            it_should_behave_like 'validation check', column, "500:600:700", "Over Limit", "con2"
            it_should_behave_like 'validation check', column, "500:60:7000", "Over Limit", "con3"
            it_should_behave_like 'validation check', column, "hoge:60:700",  "Character", "con0"
            it_should_behave_like 'validation check', column, "500:hoge:700", "Character", "con0"
            it_should_behave_like 'validation check', column, "500:60:hoge",  "Character", "con0"
            it_should_behave_like 'validation check', column, nil, "nil"
          elsif column == "sub_nid"
            it_should_behave_like 'dynamic cmd check', column, "127.0.0.0/24 127.0.0.1 localhost", group, "string"
            it_should_behave_like 'validation check', column, "127.0.0.0/24 127.0.0.1 localhost", "normal"
            it_should_behave_like 'validation check', column, "1111.2222.3333.4444/24 127.0.0.1 localhost", "Over Limit"
            it_should_behave_like 'validation check', column, nil, "nil"
          elsif column == "lost_action"
            it_should_behave_like 'dynamic cmd check', column, "shutdown", group, "string"
            it_should_behave_like 'validation check', column, "auto_assign", "normal"
            it_should_behave_like 'validation check', column, "shutdown",    "normal"
            it_should_behave_like 'validation check', column, "no_action",   "Unexpected"
            it_should_behave_like 'validation check', column, "hogehoge",    "Character"
            it_should_behave_like 'validation check', column, nil,           "nil"
          else
            raise
          end
        end
      }
    }
  end

#[Cluster function check](ph3)=================================================================
  describe "phase3" do
    roma = Roma.new
    active_routing_list = roma.change_roma_res_style(roma.get_stats["routing"]["nodes"])

    context "normal(all instance's status is active)" do
      routing_info = roma.get_routing_info(active_routing_list)

      it_should_behave_like 'get_routing_info_check', routing_info, roma.get_stats["storages[roma]"]["storage.st_class"]
    end

    context "status change check(recover)" do
      sock = TCPSocket.open(ConfigGui::HOST, ConfigGui::PORT)
      sock.write("eval @stats.run_recover = true\r\n")

      routing_info = roma.get_routing_info(active_routing_list)
      routing_info.each{|instance, info|
        if instance == "#{ConfigGui::HOST}_#{ConfigGui::PORT}"
          it "[3-13]" do expect(routing_info[instance]["status"]).to eq "recover" end
        else
          it "[3-14]" do expect(routing_info[instance]["status"]).to eq "active" end
        end
      }
      sock.write("eval @stats.run_recover = false\r\n")
      sock.close
    end

    context "status change check(join)" do
      sock = TCPSocket.open(ConfigGui::HOST, ConfigGui::PORT)
      sock.write("eval @stats.run_join = true\r\n")

      routing_info = roma.get_routing_info(active_routing_list)
      routing_info.each{|instance, info|
        if instance == "#{ConfigGui::HOST}_#{ConfigGui::PORT}"
          it "[3-15]" do expect(routing_info[instance]["status"]).to eq "join" end
        else
          it "[3-16]" do expect(routing_info[instance]["status"]).to eq "active" end
        end
      }

      sock.write("eval @stats.run_join = false\r\n")
      sock.close
    end

    context "inactive(one instance's status is inactive)" do
      dummy_active_routing_list = active_routing_list - ["#{ConfigGui::HOST}_#{ConfigGui::PORT}"]

      routing_info = roma.get_routing_info(dummy_active_routing_list)
      routing_info.each{|instance, info|
        if instance == "#{ConfigGui::HOST}_#{ConfigGui::PORT}"
          it "[3-17]" do expect(routing_info[instance]["status"]).to eq "inactive" end
          it "[3-18]" do expect(routing_info[instance]["size"]).to eq nil end
          it "[3-19]" do expect(routing_info[instance]["version"]).to eq nil end
        else
          it "[3-20]" do expect(routing_info[instance]["status"]).to eq "active" end
        end
      }
    end

    context "change_roma_res_style(array)" do
      roma_res_example_array = '["localhost_10001", "localhost_10002", "localhost_10003"]'
      res_array = roma.change_roma_res_style(roma_res_example_array)

      it "[3-21] Response is Array" do
        expect(res_array.class).to be Array
      end

      it "[3-22] Size is same number" do
        expect(res_array.size).to be 3
      end

      it "[3-23] confirm detail" do
        expect(res_array).to eq(["localhost_10001", "localhost_10002", "localhost_10003"])
      end
    end

    context "change_roma_res_style(hash)" do
      roma_res_example_hash = '{"localhost_10001"=>2062, "localhost_10002"=>2062, "localhost_10003"=>2062}'
      res_hash = roma.change_roma_res_style(roma_res_example_hash)

      it "[3-24] Response is Hash" do
        expect(res_hash.class).to be Hash
      end

      it "[3-25] Size is same number" do
        expect(res_hash.size).to be 3
      end

      it "[3-26] value's class is fixnum" do
        res_hash.values.each{|value|
          expect(value).to be_a_kind_of(Fixnum)
        }
      end

      it "[3-27] confirm detail" do
        expect(res_hash).to eq({"localhost_10001"=>2062, "localhost_10002"=>2062, "localhost_10003"=>2062})
      end
    end

    context "change_roma_res_style(Unexpected)" do
      roma_res_example_unexpected = 'hogehoge'

      it "[3-28] in case of unexpected value was send" do
        expect { roma.change_roma_res_style(roma_res_example_unexpected) }.to raise_error
      end
    end

    context "status change check(recover)" do
      res = roma.send_command('recover', nil)
      res = roma.change_roma_res_style(res)

      it "[3-29] Response is Hash" do
        expect(res.class).to be Hash
      end

      it "[3-20] Hash size is same number of active node" do
        expect(res.size).to be active_routing_list.size
      end

      it "[3-31] All instance send back 'STARTED'" do
        res.each{|key, value|
          expect(value).to eq "STARTED"
        }
      end

      it "[3-32] All instance name is same of active node list'" do
        res.each{|key, value|
          expect(active_routing_list.include?(key)).to be_true
        }
      end
    end

    context "status change check(recover) in case of failed" do
      roma.send_command('eval @stats.run_recover = true', nil)
      res = roma.send_command('recover', nil)
      res = roma.change_roma_res_style(res)

      it "[3-33] Response is Hash" do
        expect(res.class).to be Hash
      end

      it "[3-34] Hash size is same number of active node" do
        expect(res.size).to be active_routing_list.size
      end

      it "[3-35] 1 instance send back 'SERVER_ERROR'" do
        expect(res.values.include?("SERVER_ERROR Recover process is already running.")).to be_true
      end

      it "[3-36] All instance name is same of active node list'" do
        res.each{|key, value|
          expect(active_routing_list.include?(key)).to be_true
        }
      end

      roma.send_command('eval @stats.run_recover = false', nil)
    end
  end

#[login & root cmd](ph4)=================================================================
  describe "phase4" do
    test_root_info = [{:username => 'test_root_user', :password => 'test_root_password', :email => 'dev-act-roma1@mail.rakuten.com'}]
    test_normal_info = [
      {:username => 'test_normal_user1', :password => 'test_normal_password1', :email => ''},
      {:username => 'test_normal_user2', :password => 'test_normal_password2'},
    ]

    context "root login check(correct)" do
      username = 'test_root_user'
      password = 'test_root_password'
      email = 'dev-act-roma1@mail.rakuten.com'
      expected_res = [{:username => username, :password => password, :email => email}, "root"]

      it "[4-1]" do 
        stub_const("ConfigGui::ROOT_USER", test_root_info)
        expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to eq expected_res
      end
    end

    context "root login check(incorrect user)" do
      username = 'hogehoge'
      password = 'test_root_password'

      it "[4-2]" do
        stub_const("ConfigGui::ROOT_USER", test_root_info)
        expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to be_false
      end
    end

    context "root login check(incorrect password)" do
      username = 'test_root_user'
      password = 'fugafuga'

      it "[4-3]" do
        stub_const("ConfigGui::ROOT_USER", test_root_info)
        expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to be_false
      end
    end

    context "normal login check(correct) with brank email" do
      username = 'test_normal_user1'
      password = 'test_normal_password1'
      email = ''
      expected_res = [{:username => username, :password => password, :email => email}, "normal"]

      it "[4-4]" do
        stub_const("ConfigGui::NORMAL_USER", test_normal_info)
        expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to eq expected_res
      end
    end

    context "normal login check(correct) with no email column" do
      username = 'test_normal_user2'
      password = 'test_normal_password2'
      expected_res = [{:username => username, :password => password}, "normal"]

      it "[4-5]" do
        stub_const("ConfigGui::NORMAL_USER", test_normal_info)
        expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to eq expected_res
      end
    end

    context "normal login check(incorrect user)" do
      username = 'hogehoge'
      password = 'test_normal_password1'

      it "[4-6]" do
        stub_const("ConfigGui::NORMAL_USER", test_normal_info)
        expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to be_false
      end
    end

    context "normal login check(incorrect password)" do
      username = 'test_normal_user1'
      password = 'fugafuga'

      it "[4-7]" do
        stub_const("ConfigGui::NORMAL_USER", test_normal_info)
        expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to be_false
      end
    end

    context "normal login check(incorrect pattern)" do
      username = 'test_normal_user1'
      password = 'test_normal_password2'

      it "[4-8]" do
        stub_const("ConfigGui::NORMAL_USER", test_normal_info)
        expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to be_false
      end
    end

    context "get_active_routing_list" do
      stats_example = {"routing"=>{"nodes" => '["localhost_10001", "localhost_10002", "localhost_10003"]'}}
      res_active_routing_list = Roma.new.get_active_routing_list(stats_example)

      it "[4-9] Response is Array" do
        expect(res_active_routing_list.class).to be Array
      end

      it "[4-10] each data is string" do
        res_active_routing_list.each{|instance|
          expect(instance.class).to be String
        }
      end

      it "[4-11] Size is same number" do
        expect(res_active_routing_list.size).to be 3
      end

      it "[4-12] confirm detail" do
        expect(res_active_routing_list).to eq(["localhost_10001", "localhost_10002", "localhost_10003"])
      end
    end
  end

#[routing & log](ph5)=================================================================
  describe "phase5" do
    context "enabled_repetition_in_routingdump?" do
      res_repetition_info = Roma.new.enabled_repetition_in_routingdump?

      it "[5-1] Response is boolean" do
        expect(res_repetition_info.class).to be TrueClass
      end
    end

    context "get_routing_dump" do
      res_routingdump_json = Roma.new.get_routing_dump('json')
      res_routingdump_yaml = Roma.new.get_routing_dump('yaml')

      it "[5-2] Response is Array" do
        expect(res_routingdump_json.class).to be Array
        expect(res_routingdump_yaml.class).to be Array
      end

      it "[5-3] Response size is 1(json)" do
        #"routingdump json" sendback data as a 1 line
        expect(res_routingdump_json.size).to be 1
      end

      it "[5-4] Response size is over 2000 in case of redundancy is 2(yaml)" do
        #"routingdump yaml" sendback data as a multi line
        expect(res_routingdump_yaml.size).to be > 2000
      end

      it "[5-5] Error check in case of unavailable format type was sent" do
        expect { Roma.new.get_routing_dump('xml') }.to raise_error
      end
    end
  end

#[Storage](ph6)=================================================================
  describe "phase6" do
    context "test of get/set" do
      roma = Roma.new

      key = "hoge-#{Time.now.strftime('%Y/%m/%dT%H:%M:%S')}"
      value = "fuga-#{Time.now.strftime('%Y/%m/%dT%H:%M:%S')}"

      it "[6-1] get(Response is boolean)" do
        expect(roma.get_value(key).class).to be Array
      end

      it "[6-2] get(key size is 0 (unset key))" do
        expect(roma.get_value(key).size).to be 0
      end

      it "[6-3] set(set correct value) " do
        expect(roma.set_value(key, value, 0)).to eq "STORED\r\n"
      end
   
      it "[6-4] get(get correct value) " do
        expect(roma.get_value(key).size).to be 2
      end

      it "[6-5] get(get correct value) " do
        expect(roma.get_value(key)[0].class).to be String
      end

      it "[6-6] get(get correct value) " do
        expect(roma.get_value(key)[0]).to eq "VALUE #{key} 0 #{value.size}"
      end

      it "[6-7] get(get correct value) " do
        expect(roma.get_value(key)[1].class).to be String
      end

      it "[6-8] get(get correct value) " do
        expect(roma.get_value(key)[1]).to eq value
      end
    end
  end

#[v1.1.0]=================================================================
  describe "v1.1.0" do
    roma = Roma.new
    active_routing_list = roma.change_roma_res_style(roma.get_stats["routing"]["nodes"])

    context "get_all_logs_by_date" do
      it "[7-1] normal check" do
        res =  roma.get_all_logs_by_date(active_routing_list, '2001-01-01T00:00:00', '2099-12-31T00:00:00')
        expect(res.class).to be Hash
        expect(res.size).to be active_routing_list.size
        expect(res.values.flatten.size).to be > 0
      end

      it "[7-2] brank value check" do
        expect { roma.get_all_logs_by_date(active_routing_list, '', '') }.to raise_error
      end

      it "[7-3] irregular value check" do
        res = roma.get_all_logs_by_date(active_routing_list, '2099-01-01T00:00:00', '2099-12-31T00:00:00')
        expect(res.class).to be Hash
        expect(res.size).to be active_routing_list.size
        expect(res.values.flatten.size).to be 0
      end

      it "[7-4] irregular format value check" do
        expect { roma.get_all_logs_by_date(active_routing_list, '2001/01/01 00:00:00', '2099/12/31 00:00:00') }.to raise_error
      end
    end
  end

end # End of describe
