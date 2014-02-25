require 'pp'
class OutgraderController < ApplicationController
  @@is_started = false
  @@ip = '93.44.12.15'
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
    @is_started = @@is_started
    @ip = @@ip
    @outgrader = self
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
    @@ip = params[:ip]
    redirect_to outgrader_path, notice:'Адрес изменен'
  end

end
