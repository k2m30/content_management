class VisitsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:send_click, :send_visit]

  def index
    @visits = Visit.all.reverse
  end

  def send_click
    params[:url] = 'http://www.kinopoisk.ru/film/77331/' if params[:url].nil?
    link = Link.find_by(url: params[:url])
    Visit.create(remote_ip: @_env["HTTP_X_FORWARDED_FOR"] || @_env["REMOTE_ADDR"], time: Time.now.to_formatted_s(:short), link: link, is_click: true) unless link.nil?

    response.headers['Access-Control-Allow-Origin'] = '*'
    render text: "click from #{@_env["HTTP_X_FORWARDED_FOR"]},  #{@_env["REMOTE_ADDR"]}", status: :ok
  end

  def send_visit
    params[:url] = 'http://www.kinopoisk.ru/film/77331/' if params[:url].nil?
    link = Link.find_by(url: params[:url])
    Visit.create(remote_ip: @_env["HTTP_X_FORWARDED_FOR"] || @_env["REMOTE_ADDR"],
                 time: Time.now.to_formatted_s(:short), link: link,
                 is_click: false, url: params[:url],
                 film: params[:name] + ', ' + params[:year]) if params[:url].start_with? 'http://www.kinopoisk.ru/film' #TODO remove hardcode

    response.headers['Access-Control-Allow-Origin'] = '*'
    render text: "visit from #{@_env["HTTP_X_FORWARDED_FOR"]},  #{@_env["REMOTE_ADDR"]}", status: :ok
  end
end
