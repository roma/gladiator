require 'spec_helper'

shared_examples_for 'dynamic cmd check' do |key, value, group, pattern|
  let(:roma) { Roma.new }
  let(:dynamic) { roma.change_param(key, value) }
  let(:actual_stats_normal) { roma.get_stats }
 
  if key == 'lost_action' && Roma.new.get_stats['routing']['lost_action'].chomp == 'no_action'
    next
  end

  # return message check
  it "[2-1]Return param check[key=>#{key} / value = #{value} / check pattern=> Hash or not]" do
    expect(dynamic).to be_true
  end
  it "[2-2]Return param check[key=>#{key} / value = #{value} / check pattern=> Size > 1]" do
    expect(dynamic.size).to be > 1
  end
  it "[2-3]Return param check[key=>#{key} / value = #{value} / check pattern=> msg is 'STORED']" do
    dynamic.values.each{|v|
      if key == "dns_caching"
        expect(v.chomp).to eq("ENABLED")
      elsif key == "sub_nid"
        expect(v.chomp).to eq("ADDED")
      else
        expect(v.chomp).to eq("STORED")
      end
    }
  end

  # check reflected or not
  case pattern
  when "string"
    it "[2-4]Reflected check[key=>#{key} / value = #{value}]" do
      if key == "sub_nid"
        sub_value = value.split(nil)
        sub_value = "{\"#{sub_value[0]}\"=>{:regexp=>\"#{sub_value[1]}\", :replace=>\"#{sub_value[2]}\"}}"
        expect(actual_stats_normal[group][key].chomp ).to eq(sub_value)
      else
        expect(actual_stats_normal[group][key].chomp ).to eq(value)
      end
    end
  when "boolean"
    it "[2-5]Reflected check[key=>#{key} / value = #{value}]" do
      expect(actual_stats_normal[group][key].chomp ).to eq(value)
    end
  else
    raise
  end
end # end of example "dynamic cmd check"


shared_examples_for 'validation check' do |key, value, pattern, continous_limit_pattern|
  let(:roma) { Roma.new(key => value) }
  case pattern
  when "normal"
    if key == "dns_caching" || key == "auto_recover" || key == "lost_action"
      it "[2-6][normal test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
        expect(roma.check_param(key, value)).to be_true
      end
    else
      it "[2-7][normal test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
        expect(roma.valid?).to be_true
      end
    end

  when "under0", "Over Limit", "Character", "Over Length", "Unexpected"
    if key == "dns_caching" || key == "auto_recover" || key == "lost_action"
      it "[2-8][error test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
        expect(roma.check_param(key, value)).to be_false
        err = error_msg(key,  continous_limit_pattern)
        expect(roma.errors.full_messages[0]).to eq(err)
      end
    else
      it "[2-9][error test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
        expect(roma.valid?).to be_false
        err = error_msg(key,  continous_limit_pattern)
        expect(roma.errors.full_messages[0]).to eq(err)
      end
    end

  when "nil"
    it "[2-10][error test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
      expect(roma.check_param(key, value)).to be_false
    end

  else
    raise
  end
end # end of example "validation check"


def error_msg(key, continous_limit_pattern = nil)
  case key
  when "dcnice"
    "#{key.capitalize.gsub(/_/, " ")}  : You sholud input a priority from 1 to 5."
  when "size_of_zredundant", "spushv_klength_warn", "spushv_vlength_warn", "shift_size"
    "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 2147483647."
  when "hilatency_warn_time"
    "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 60."
  when "routing_trans_timeout", "accepted_connection_expire_time", "pool_expire_time", "EMpool_expire_time"
    "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 86400."
  when "fail_cnt_threshold"
    "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 100."
  when "fail_cnt_gap"
    "#{key.capitalize.gsub(/_/, " ")}  : number must be from 0 to 60."
  when "pool_maxlength", "EMpool_maxlength"
    "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 1000."
  when "descriptor_table_size"
    "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1024 to 65535."
  when "sub_nid"
    "#{key.capitalize.gsub(/_/, " ")}  : Target NetMask is no more than 20 characters."
  when "lost_action"
    "#{key.capitalize.gsub(/_/, " ")}  : Unexpected Error. This value is required"
  when "dns_caching"
    "#{key.capitalize.gsub(/_/, " ")}  : Unexpected Error. This value is required"
  when "auto_recover"
    "#{key.capitalize.gsub(/_/, " ")}  : Unexpected Error. This value is required"
  when "continuous_limit"
    if  continous_limit_pattern == "con0"
      "#{key.capitalize.gsub(/_/, " ")}  : All fields must be number and required."
    elsif  continous_limit_pattern == "con1" || continous_limit_pattern == "con3"
      "#{key.capitalize.gsub(/_/, " ")}  : nubmer must be from 1 to 1000."
    elsif  continous_limit_pattern == "con2"
      "#{key.capitalize.gsub(/_/, " ")}  : nubmer must be from 1 to 100."
    end
  else
    raise
  end
end

shared_examples_for 'get_routing_info_check' do |routing_info|
  it "[3-1]" do expect(routing_info).to be_a_kind_of(Hash) end # Hash or Not
  it "[3-2]" do expect(routing_info.size).to be > 1 end # over 2 instances
  it "[3-3]" do expect(routing_info.keys.uniq!).to be nil end # duplicate check

  routing_info.each{|instance, info|
    it "[3-4]" do expect(instance).to match(/^[-\.a-zA-Z\d]+_[\d]+/) end
    it "[3-5]" do expect(info).to be_a_kind_of(Hash) end # Hash or Not
    it "[3-6]" do expect(info.size).to be (4+info["redundant"]) end # Status & Size & Version & redundant & primaryVnodes & secondaryX

    # Status check
    it "[3-7]" do expect(info["status"]).to be_a_kind_of(String) end
    it "[3-8]" do expect(info["status"]).to eq("active") end # all instance's status should be active
    # Size check
    it "[3-9]" do expect(info["size"]).to be_a_kind_of(Fixnum) end
    it "[3-10]" do expect(info["size"]).to be > 209715200 end # 1 tc file is over 20 MB at least
    # Version check
    it "[3-11]" do expect(info["version"]).to be_a_kind_of(String) end
    it "[3-12]" do expect(info["version"]).to match(/^\d\.\d\.\d+[-dev]*$|^\d\.\d\.\d+\-p\d+$/) end #/^\d\.\d\.\d+\-p\d+$/ is for 0.8.13-p1

    # primary nodes count check
    it "[4-1]" do expect(info["primary_nodes"]).to be_a_kind_of(Fixnum) end
    it "[4-2]" do expect(info["primary_nodes"]).to be > 0 end
    # secondary nodes count check
    (info["redundant"]-1).times{|i|
      it "[4-3]" do expect(info["secondary_nodes#{i+1}"]).to be_a_kind_of(Fixnum) end
      it "[4-4]" do expect(info["secondary_nodes#{i+1}"]).to be > 0 end
    }
  }
end

