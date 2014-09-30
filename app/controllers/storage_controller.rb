class StorageController < ApplicationController
  def index
    roma = Roma.new

    @stats_hash = roma.get_stats
    active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
    routing_info = roma.get_routing_info(active_routing_list, 'gui_run_snapshot')
    routing_info.each{|instance, info|
      flash.now[:snapshoting] = instance if info['gui_run_snapshot']
    }
    gon.snapshoting = flash.now[:snapshoting]

    @last_snapshot_data = @stats_hash["stats"]["gui_last_snapshot"]
    @last_snapshot_data = 'never execute snapshot after (re)boot ROMA' if @last_snapshot_data == '[]'
  end

end
