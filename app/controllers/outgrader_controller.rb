require 'pp'
require 'net/http'
require 'watir-webdriver'
require 'date'
require 'headless'

class OutgraderController < ApplicationController
  skip_before_filter  :verify_authenticity_token, only: [:send_click]

  def initialize
    @outgrader = Param.first || Param.create
    super
  end

  def send_click

    response.headers['Access-Control-Allow-Origin'] = '*'
    render text: "sent from #{params}:#{@_headers}, #{@_request}, #{@_env}",status: :ok
  end

  def get_redirect
    begin
      url = params[:url]
      url+='/' if not url.end_with?('/')
      site = Link.find_site(url)
      internal_link = site.links.find_by(url: url)
      href = internal_link.content.url

      render text: "var outgrader_url=\"#{Param.first.redirector_ip}\"; var href=\"#{href}\"; #{site.banner}", status: :ok
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
    if not ENV['USER']=='Mikhail'
      headless = Headless.new
      headless.start
    end
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile.proxy = Selenium::WebDriver::Proxy.new :http => "#{@outgrader.outgrader_ip}:8888" #TODO remove hardcode port
    browser_proxy = Watir::Browser.new :firefox, :profile => profile
    browser_straight = Watir::Browser.new :firefox
    @results = Hash.new
    Link.all.map(&:url).each do |url|
      t1 = Time.now
      browser_proxy.goto(url)
      t2 = Time.now
      browser_straight.goto(url)
      t3 = Time.now
      div = browser_proxy.div(id: 'outgrader_button')
      @results[url]=[(t2-t1).round(2),(t3-t2).round(2), div.exists?]
    end
    browser_proxy.close
    browser_straight.close
    if not ENV['USER']=='Mikhail'
      headless.destroy
    end
    #@results = {"http://www.kinopoisk.ru/film/5679/"=>[8.46135, 7.246602], "http://films.imhonet.ru/element/189455/"=>[8.393671, 5.261059], "http://www.kinopoisk.ru/film/77331/"=>[4.995837, 33.41228]}
    @hash = ENV.to_hash
    #redirect_to outgrader_path, notice: 'Тест запущен'
  end

end
