class RoutingController < ApplicationController
  def index
    roma = Roma.new

    @stats_hash = roma.get_stats
    @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])

    @enabled_repetition_in_routingdump = roma.enabled_repetition_in_routingdump?
    @routing_event = roma.change_roma_res_style(@stats_hash["routing"]["event"])
  end

  def download
    roma = Roma.new

    format = params[:format]
    if self.class.helpers.dump_format_check(format)
      routing_dump = roma.get_routing_dump(format)
      send_data(routing_dump, :filename => "routingdump.#{format}")
    else
      @stats_hash = roma.get_stats
      @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
      @enabled_repetition_in_routingdump = roma.enabled_repetition_in_routingdump?
      @routing_event = roma.change_roma_res_style(@stats_hash["routing"]["event"])
      gon.format_error = true
      render :action => "index.html.erb"
    end
  end
end
