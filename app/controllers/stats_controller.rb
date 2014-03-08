require 'date'
class StatsController < ApplicationController
  def choose_dates
    @begin_date = DateTime.now - 1
    @end_date = DateTime.now
  end

  def results
    begin
      begin_date = DateTime.parse(params[:from]).strftime('%Q')
      end_date = DateTime.parse(params[:to]).strftime('%Q')
      outgrader = Param.first || Param.create
      port = outgrader.outgrader_port
      ip = outgrader.outgrader_ip
      uri = URI("http://#{ip}:#{port}/statistics?from=#{begin_date}&to=#{end_date}")
      response = Net::HTTP.get uri

      @visits = ActiveSupport::JSON.decode response
    rescue
      redirect_to stats_choose_dates_path, alert: 'Сервер недоступен'
      return
    end
  end
end
