class OutgraderController < ApplicationController
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
      site = Link.find_site(url)
      internal_link = site.links.find_by(url: url)
      href = internal_link.content.url

      render text: 'var href="' << href << '";' << site.banner, status: :ok
    rescue => e
      render text: 'error: ' << e.message, status: :unassigned
    end
  end

end
