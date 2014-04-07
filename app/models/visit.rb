require 'nokogiri'
require 'open-uri'

class Visit < ActiveRecord::Base
  belongs_to :link

  def self.stats(from=nil, to=nil)
    if from.present? && to.present?
      full_list = Visit.where(link_id: nil, time: [from..to]).pluck(:film)
    else
      full_list = Visit.where(link_id: nil).pluck(:film)
    end
    short_list = full_list.uniq

    short_list.map{|film| [film, full_list.count(film)]}.sort_by{|film| film[1]}.reverse
  end

  def self.get_torrents
    html = Nokogiri::HTML open 'http://kinozal.tv/top.php'
    films = html.css '.stable a'
    torrents = Array.new(films.size){{}}
    films.each_with_index do |film, i|
      title = film[:title]
      torrents[i][:name] = title.split('/').first.strip
      torrents[i][:year] = title[/\d{4,}/]
      torrents[i][:quality] = title.split('/').last.strip

      content = Content.find_by(name: "#{torrents[i][:name]}, #{torrents[i][:year]}")
      torrents[i][:files_number] = content.present? ? content.video_files.size : 0
    end
    torrents.select! {|torrent| VideoFile::QUALITIES.include? torrent[:quality]}
    torrents.sort_by! {|torrent| torrent[:files_number]}
  end
end
