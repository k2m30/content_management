require 'open-uri'
require 'nokogiri'

class Content < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :sites, through: :links
  has_many :video_files, dependent: :destroy
  validates :name, presence: true

  USER_AGENTS = ['Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36',
                 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11',
                 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.102 Safari/537.36 OPR/19.0.1326.59',
                 'Opera/9.80 (Windows NT 5.1; U; en) Presto/2.2.15 Version/10.10',
                 'Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.5) Gecko/20091112 Iceweasel/3.5.5 (like Firefox/3.5.5; Debian-3.5.5-1)']


  def self.text_search(query)
    query.present? ? search(query) : all
  end

  def self.find_content(url, site)
    url+='/' unless url.end_with?('/')

    html = Nokogiri::HTML open(url, 'User-Agent' => Content::USER_AGENTS.sample)
    name = html.at_css(site.name_css).content
    year = html.at_css(site.year_css).content

    content = Content.text_search("#{name}, #{year}").first
    site.links.create(url: url, content: content) if content.present?

    return content
  rescue => e
    logger.error url
    logger.error e.message
    logger.error e.backtrace[0..3]
    return nil
  end

  def self.create_with_kinopoisk(link)
    link+='/' unless link.end_with?('/')

    html = Nokogiri::HTML open(link, 'User-Agent' => Content::USER_AGENTS.sample)
    info = html.at_css('.info')
    info.css('a').each do |a|
      a[:href] = 'http://www.kinopoisk.ru' + a[:href] if a[:href].present? && a[:href].start_with?('/')
      a[:target] = '_blank'
    end
    info = info.to_html.encode('utf-8')

    rating = html.at_css('.block_2')
    if rating.present?
      rating.css('a').each do |a|
        a[:href] = 'http://www.kinopoisk.ru' + a[:href] if a[:href].present? && a[:href].start_with?('/')
        a[:target] = '_blank'
      end
      rating = rating.to_html.encode('utf-8')
    end

    description = html.at_css('._reachbanner_ .brand_words')
    description = description.to_html.encode('utf-8') if description.present?

    image = "http://www.kinopoisk.ru/images/film/#{link[/\d+/]}.jpg"

    name = html.at_css('title').content
    year = html.at_css('#infoTable tr:nth-child(1) a').content

    content = Link.find_by(url: link).present? ? Link.find_by(url: link).content : Content.new
    content.info = info
    content.rating = rating
    content.description = description
    content.image = image
    content.name = "#{name}, #{year}"
    content.save
    content.links.create(url: link, site: Site.find_by(name: 'kinopoisk.ru'))
    return content
  rescue => e
    logger.error [link, e.message, e.backtrace]
    nil
  end
end