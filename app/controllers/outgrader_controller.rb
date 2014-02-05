class OutgraderController < ApplicationController
  def all
    array = []
    Site.all.each do |site|
      array << {site: site.name, code: site.banner, css: site.css, links: site.links.pluck(:url)}
    end
    render json: array
  end
end
