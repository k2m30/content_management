require 'will_paginate/array'

class VisitsController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :downloads, :most_wanted]
  skip_before_filter :verify_authenticity_token, only: [:send_click, :send_visit]

  def index
    @visits = Visit.order(time: :desc).paginate(page: params[:page], per_page: 50)
    @stats = Array.new(24) {{}}
    @stats.each_with_index do |a, i|
      a[:hour] = i.to_s
      visits = Visit.all.select {|visit| visit.time.hour == i}
      a[:visits] = visits.count
      a[:downloads] = visits.select {|visit| visit.is_click? }.count
      a[:users] = visits.map(&:remote_ip).uniq.count
    end
  end

  def downloads
    @visits = Visit.where(is_click: true).order(time: :desc).paginate(page: params[:page], per_page: 50)
    render action: :index
  end

  def most_wanted
    @list = Visit.stats(params[:from], params[:to]).paginate(page: params[:page], per_page: 10)
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
