require 'pp'
require 'net/http'
require 'watir-webdriver'
require 'date'
require 'headless'

class OutgraderController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:get_redirect]

  def initialize
    @outgrader = Param.first || Param.create
    super
  end

  def get_redirect
    begin
      url = @_request.env["HTTP_REFERER"]
      url+='/' unless url.end_with?('/')
      site = Link.find_site(url)

      if site.nil? || url.match(site.regexp).nil?
        render text: nil
        return
      end

      link = Link.find_by(url: url)
      content = nil
      if link.present?
        content = link.content
      else
        content = site.standard? ? Content.create_with_kinopoisk(url) : Content.find_content(url, site)
      end

      @site = site
      if content.present? && !content.video_files.empty?
        @href = content_url(content)
      else
        @href = nil
      end
    rescue
      @site = nil
      @href = nil
    end
    @request = request
    response.headers['Access-Control-Allow-Origin'] = '*'
    render action: :get_redirect, layout: nil
  end

  def index
    begin
      @config_hash = get_action(:config).merge(get_action(:'redirector/config'))
      @state_hash = get_action(:state).merge(get_action(:version))

      @state_hash['startDate'] = pluck_date(@state_hash['startDate'])
      @state_hash['activationDate'] = pluck_date(@state_hash['activationDate'])
      @state_hash['buildDate'] = pluck_date(@state_hash['buildDate'])

      @outgrader.update(outgrader_status: @state_hash[:state])
    rescue
      @config_hash = @state_hash = Hash.new
      flash[:alert]= 'Сервер недоступен'
    end
  end

  def pluck_date(timestamp)
    return DateTime.strptime(timestamp.to_s, '%Q').strftime('%d/%m/%Y %T')
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
    rescue
      redirect_to outgrader_path, alert: 'Ошибка изменения адреса'
    end
    redirect_to outgrader_path, notice: 'Адрес изменен'
  end

end
