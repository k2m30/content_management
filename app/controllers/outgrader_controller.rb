require 'pp'
require 'net/http'
require 'watir-webdriver'
require 'date'

class OutgraderController < ApplicationController
  @@is_started = false
  attr_accessor :is_started

  #def all
  #  array = []
  #  Site.all.each do |site|
  #    array << {site: site.name, code: site.banner, css: site.css, links: site.links.pluck(:url)}
  #  end
  #  render json: array
  #end

  #def stats
  #  render text: 'ok'
  #end
  def initialize
    @outgrader = Param.first || Param.create
    super
  end

  def get_redirect
    begin
      url = params[:url]
      url+='/' if not url.end_with?('/')
      site = Link.find_site(url)
      internal_link = site.links.find_by(url: url)
      href = internal_link.content.url
      pp params

      render text: 'var href="' << href << '";' << site.banner, status: :ok
    rescue => e
      render text: 'error: ' << e.message, status: :ok
    end
  end

  def index
    begin
      @config_hash = get_action(:config).merge(get_action(:'redirector/config'))
      @state_hash = get_action(:state).merge(get_action(:version))

      @state_hash['startDate'] = pluck_date(@state_hash['startDate'])
      @state_hash['activationDate'] = pluck_date(@state_hash['activationDate'])

      @outgrader.update(outgrader_status: @state_hash[:state])
    rescue
      @config_hash = @state_hash = Hash.new
      flash[:alert]= 'Сервер недоступен'
    end
  end

  def pluck_date(timestamp)
    date = timestamp.to_s
    date = date[0..date.length-4]
    return DateTime.strptime(date, '%s').strftime('%d/%m/%Y %T')
  end

  def get_action(action)
    port = @outgrader.outgrader_port
    ip = @outgrader.outgrader_ip
    uri = URI("http://#{ip}:#{port}/#{action}")
    response = Net::HTTP.get uri

    return ActiveSupport::JSON.decode response
  end

  def change_config
    begin
      port = @outgrader.outgrader_port
      ip = @outgrader.outgrader_ip

      uri = URI("http://#{ip}:#{port}/#{:change_config}")
      Net::HTTP.post_form uri, params
      dsf
      #rescue
      #  redirect_to outgrader_path, alert: 'Сервер не отвечает'
      #  return
    end
    redirect_to outgrader_path, notice: 'Настройки изменены'
  end

  def start
    put_action('start')
    redirect_to outgrader_path, notice: 'Outgrader запущен'
  end

  def stop
    put_action('stop')
    redirect_to outgrader_path, notice: 'Outgrader остановлен'
  end

  def restart
    put_action('restart')
    redirect_to outgrader_path, notice: 'Outgrader перезапущен'
  end

  def kill
    put_action('kill')
    redirect_to outgrader_path, notice: 'Outgrader принудительно остановлен'
  end

  def put_action(action)
    begin
      port = @outgrader.outgrader_port
      ip = @outgrader.outgrader_ip
      Net::HTTP.get(URI("http://#{ip}:#{port}/#{action}"))
    rescue
    end
  end

  def outgrader_change_ip
    @outgrader.update(outgrader_ip: params[:ip].gsub('http://', ''), outgrader_port: params[:port])
    redirect_to outgrader_path, notice: 'Адрес изменен'
  end

  def redirector_change_ip
    begin
      @outgrader.update(redirector_ip: params[:ip].gsub('http://', ''))
      redirect_js = "$.ajax({url: \"http://#{@outgrader.redirector_ip}/outgrader/get_redirect.js\?url=\" + location.href, dataType: \"script\"});"
      f = File.open('./public/redirector.js', 'w+')
      f.write(redirect_js)
      f.close
    rescue
      redirect_to outgrader_path, alert: 'Ошибка изменения адреса'
    end
    redirect_to outgrader_path, notice: 'Адрес изменен'
  end

  def test
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile.proxy = Selenium::WebDriver::Proxy.new :http => "#{@outgrader.outgrader_ip}:8888"
    browser = Watir::Browser.new :firefox, :profile => profile
    Link.all.map(&:url).each do |url|
      browser.goto(url)
    end

    redirect_to outgrader_path, notice: 'Тест запущен'
  end

end
