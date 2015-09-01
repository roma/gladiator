require 'spec_helper'

puts "[Controller test(api_controller_spec.rb)]***************************"

begin
  roma = Roma.new
  env = roma.get_stats

  routing_history = roma.get_all_routing_list
  raise if routing_history.include?('77777')

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
      2. No node is down.
      3. ROMA's port No. do NOT include '77777'
         (Rspec test use this port No.)
  EOS
  puts prepare
  exit!
end

describe ApiController do
  before do
    controller.class.skip_before_filter :check_logined_filter
  end

  describe "get_parameter func check" do
    describe "GET get_parameter" do
      before do
        get 'get_parameter'
      end

      it "returns http success(200)" do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "get correct infomation" do
        hash_correct = JSON.parse(response.body)
        expect(hash_correct['stats']['name']).to eq('ROMA')
        expect(hash_correct.size).to be 7
        hash_correct.each{|key, value|
          expect(hash_correct[key].class).to eq Hash
          expect(hash_correct[key].size).to be > 0
        }
      end
    end # End describe "GET get_parameter" 

    describe "GET 'get_parameter(with parameters)" do
      before do
        get 'get_parameter', {:host => ConfigGui::HOST, :port => ConfigGui::PORT }
      end

      it "returns http success(200)" do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "get correct infomation" do
        hash_correct_params = JSON.parse(response.body)
        expect(hash_correct_params['stats']['name']).to eq('ROMA')
        expect(hash_correct_params.size).to be 7
        hash_correct_params.each{|key, value|
          expect(hash_correct_params[key].class).to eq Hash
          expect(hash_correct_params[key].size).to be > 0
        }
      end
    end # End of "GET 'get_parameter(with parameters)"

    describe "GET 'get_parameter(in case of exception)" do
      before do
        get 'get_parameter', { :host => ConfigGui::HOST, :port => 77777 }
      end

      it "returns http success(200)" do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "get error information" do
        hash_exception = JSON.parse(response.body)
        expect(hash_exception.size).to be 1
        expect(hash_exception.keys).to eq(['status'])
        expect(hash_exception['status']).not_to be_nil
      end
    end
  end # End of "get_parameter func check"

  describe "[get_routing_info] func check" do
    describe "GET get_routing_info" do
      before do
        get 'get_routing_info'
      end

      it "[2-1] returns http success(200)" do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "[2-2] get correct infomation" do
        hash_correct = JSON.parse(response.body)

        expect(hash_correct.size).to be > 0
        hash_correct.each{|key, value|
          expect(hash_correct[key].class).to eq Hash
          expect(hash_correct[key].size).to be > 0
        }
        hash_correct.each_key{|key|
          expect(key).to match(/^(\d+\.\d+\.\d+\.\d+)_(\d+)$|^[0-9a-zA-Z]+_(\d+)$/)
        }
        hash_correct.each_value{|value|
          expect(value["status"]).to match(/active|inactive|release|recover|unknown|join/)
          expect(value["size"].class).to be Fixnum
          expect(value["size"]).to be > 0
          expect(value["version"]).to match(/^(\d+\.\d+\.\d+)[-]*p*[\d]*/)
          expect(value["redundant"].class).to eq Fixnum
          expect(value["redundant"]).to be > 1
          expect(value["primary_nodes"].class).to eq Fixnum
          expect(value["primary_nodes"]).to be > 0
          (value["redundant"] - 1).times{|i|
            expect(value["secondary_nodes#{i+1}"].class).to eq Fixnum
            expect(value["secondary_nodes#{i+1}"]).to be > 0
          }

        }
      end
    end
  end # End of "get_routing_info cunc check"

end # End of describe ApiController
