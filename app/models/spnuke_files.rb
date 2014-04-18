require 'pp'
require 'open-uri'
require 'nokogiri'
require 'erb'
include ERB::Util

class SpnukeFiles < ActiveRecord::Base
  #establish_connection :td
  CATEGORIES = [3, 33, 37, 40, 41, 44, 47, 49, 50, 51, 52, 53, 57, 58, 59, 61, 63, 64, 66, 92, 93, 97, 103, 104, 105, 111, 295, 297, 581, 643, 961, 2007, 2179, 2215, 2360, 6799, 7090, 8173, 8473, 8969, 9007, 9961, 10249, 10575, 11524, 12140, 12163, 13004, 13729, 13800, 13808, 13828]
  QUALITIES = ["WEB-DL 1080p", "WEB-DL 720p", "WEB-DL 1080", "WEB-DL720p", "WEB-DLRip", "WЕB-DLRip", "HD 1080p", "ВD 1080р", "WEB 720p", "BD 1080p", "HD 720p", "BR 720p", "BD 720p", "ВD 720p", "ВD 720р", "hd 720p", "DVBRip", "SatRip", "CAMRip", "DVDScr", "DVDRip", "WEBRip", "DVDRIp", "satrip", "SATrip", "DVDrip", "WebRip", "VHSRip", "SATRip", "dvdrip", "DVDip", "hdrip", "DVRip", "НDRip", "TVRip", "HDRip", "bdrip", "BRip", "HD", "TS", "BD"]

  def get_quality
    QUALITIES.each do |quality|
      return quality if self.files_url.split('/').last.gsub('%20', ' ').match(quality).present?
    end
    return nil
  end

  def get_year
    return self.files_url.split('/').last.gsub('%20', ' ')[/19\d{2}|20\d{2}/].to_i
  end

  def stats
    [self.get_external, self.get_quality, self.get_year]
  end

  def get_size
    self.files_size/1024/1024/1024.round(2)
  end

  def sync
    file = self
    p file.files_title
    video = VideoFile.find_by(internal_name: file.files_title, year: file.get_year)
    if video.present?
      p 'present'
      if file.get_url != video.internal_url
        video.update(internal_url: file.get_url)
        p 'update'
      end
    else
      p 'new'
      external = file.get_external
      unless external.empty?
        p 'create'
        VideoFile.create(internal_name: file.files_title, internal_url: file.get_url,
                         quality: file.get_quality, year: file.get_year,
                         external_name: external[:name], external_url: external[:url])
      end
    end
  end

  #187800
  def self.sync_all(start_id = 1)
    files = SpnukeFiles.where('files_id > ?',start_id).where(files_cat_id: SpnukeFiles::CATEGORIES)
    files.each(&:sync)
  end

  def get_external
    base_url = 'http://www.kinopoisk.ru/'
    user_agents = ['Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36',
                   'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11',
                   'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.102 Safari/537.36 OPR/19.0.1326.59',
                   'Opera/9.80 (Windows NT 5.1; U; en) Presto/2.2.15 Version/10.10',
                   'Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.5) Gecko/20091112 Iceweasel/3.5.5 (like Firefox/3.5.5; Debian-3.5.5-1)']
    begin
      file_extention = '.' + self.files_title.split('.').last
      film_name = self.files_title.gsub(file_extention, '')
      query = url_encode(self.files_title)
      uri = URI.parse("http://www.kinopoisk.ru/index.php?level=7&from=forma&result=adv&m_act%5Bfrom%5D=forma&m_act%5Bwhat%5D=content&m_act%5Bfind%5D=#{query}")
      html = Nokogiri::HTML open uri, 'User-Agent' => user_agents.sample
      remote_year = html.at_css('.most_wanted .year').text
      remote_name = html.at_css('.most_wanted .name a').text
      url = base_url + /film\/\d{3,}/.match(html.at_css('.most_wanted .name a')['href']).to_s
      p "#{self.files_title}, #{self.get_year}, #{remote_name}, #{remote_year}"

      if self.get_year == remote_year.to_i || (self.get_year == remote_year.to_i+1 && film_name == remote_name)
        return {name: "#{remote_name}, #{remote_year}", url: url}
      else
        return {}
      end
    rescue => e
      puts e.message
      puts e.backtrace[0..3]
      return {}
    end
  end

  def get_url
    media = self.files_url.split('/').first
    case media
      when 'MediaC', 'MediaD', 'MediaE', 'MediaG', 'MediaG092', 'MediaI', 'MediaI092', 'MediaJ', 'MediaL', 'MediaQ'
        port=8888
      when 'MediaM', 'MediaM092', 'MediaV', 'MediaS', 'MediaT', 'MediaR'
        port=8889
      when 'MediaN', 'MediaO', 'MediaU'
        port=8893
      when 'MediaF', 'MediaF092', 'MediaH', 'MediaH092', 'MediaK', 'MediaP'
        port=8891
      else
        return self.files_url
    end
    return "http://#{self.files_server.downcase}.unet.by:#{port}/#{self.files_url}"
  end

end
