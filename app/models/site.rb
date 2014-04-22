require 'open-uri'
require 'nokogiri'

class Site < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :contents, through: :links
  validates :name, presence: true, uniqueness: true

  def find_content(url)
    url+='/' unless url.end_with?('/')
    user_agents = ['Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36',
                   'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11',
                   'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.102 Safari/537.36 OPR/19.0.1326.59',
                   'Opera/9.80 (Windows NT 5.1; U; en) Presto/2.2.15 Version/10.10',
                   'Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.5) Gecko/20091112 Iceweasel/3.5.5 (like Firefox/3.5.5; Debian-3.5.5-1)']

    html = Nokogiri::HTML open(url, 'User-Agent' => user_agents.sample)
    name = html.at_css self.year_css
    year = html.at_css self.year_css

    content = Content.text_search("#{name}, #{year}").first
    if content.present?
      self.links.create(url: url, content: content)
    else
      content = Content.create(name: "#{name}, #{year}")
      self.links.create(url: url, content: content)
    end
    return content
  rescue => e
    logger.error [url, e.message, e.backtrace]
    return nil
  end
end
