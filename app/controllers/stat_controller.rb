class StatController < ApplicationController
  def index
    @stats_hash = Roma.new.get_stats
  end

  def edit
    @key   = params[:key]
    @value = params[:value]
    @roma = Roma.new(@key => @value)
    @stats_hash = @roma.get_stats
    catch :find_current_value do
      @stats_hash.each_value{|params_hash|
         params_hash.each{|key, value|
           if key == @key
             @current_value = value
             throw :find_current_value
           end
         }
      }
    end
  end

  def update
    @key = params[:key]
    if @key == "continuous_limit"
      @value = "#{params[:continuous_start]}:#{params[:continuous_rate]}:#{params[:continuous_full]}"
    elsif @key == "sub_nid"
      @value = "#{params[:sub_nid_netmask]} #{params[:sub_nid_target]} #{params[:sub_nid_string]}"
    else
      @value = params[@key]
    end
    @roma = Roma.new(@key => @value)

    if @roma.check_param(@key, @value) && @roma.valid?
      @res = @roma.change_param(@key, @value)
    end

    @stats_hash = @roma.get_stats
    catch :find_current_value do
      @stats_hash.each_value{|params_hash|
         params_hash.each{|key, value|
           if key == @key
             @current_value = value
             throw :find_current_value
           end
         }
      }
    end
    render :action => "edit"
  end
end
