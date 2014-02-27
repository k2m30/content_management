require 'pp'
require 'net/http'

class OutgraderController < ApplicationController
  @@is_started = false
  attr_accessor :is_started
  def all
    array = []
    Site.all.each do |site|
      array << {site: site.name, code: site.banner, css: site.css, links: site.links.pluck(:url)}
    end
    render json: array
  end

  def stats
    render text: 'ok'
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
    @is_started = Param.first.outgrader_status == 'active' ? true : false
    Param.create if Param.first.nil?
    @ip = Param.first.outgrader_ip
    @port = Param.first.outgrader_port
  end

  def get_config
    port = Param.first.outgrader_port
    ip = Param.first.outgrader_ip
    version_hash = Hash.new
    stats_addresses = %w[version state config redirector/config]
    stats_addresses.each do |address|
      uri = URI("http://#{ip}:#{port}/#{address}")
      response = Net::HTTP.get(uri)
      version_hash.merge!(ActiveSupport::JSON.decode(response))
    end

    render json: version_hash
  end

  def start
    @@is_started = true
    redirect_to outgrader_path, notice:'Outgrader запущен'
  end

  def stop
    @@is_started = false
    redirect_to outgrader_path, notice:'Outgrader остановлен'
  end

  def restart
    @@is_started = true
    redirect_to outgrader_path, notice:'Outgrader перезапущен'
  end

  def kill
    @@is_started = false
    redirect_to outgrader_path, notice:'Outgrader принудительно остановлен'
  end

  def change_ip
    Param.first.update(outgrader_ip: params[:ip])
    redirect_to outgrader_path, notice:'Адрес изменен'
  end

end
