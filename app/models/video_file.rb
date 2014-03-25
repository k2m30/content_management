class VideoFile < ActiveRecord::Base
  belongs_to :content
  has_many :links, through: :content

  def self.import
    site = Site.find_by(name: 'kinopoisk.ru')

    SpnukeFiles.where.not(remote_url: nil).each do |spnuke|
      video = VideoFile.create(external_name: spnuke.remote_name, external_url: spnuke.remote_url,
                           internal_name: spnuke.files_title, internal_url: spnuke.files_url,
                           quality: spnuke.quality, size: (spnuke.files_size.to_f/1024/1024/1024).round(2), year: spnuke.year)
      p ['------------------',video.id, "\n\n"]
      content = Content.find_by(name: video.external_name) ||
          Content.create(name: video.external_name)
      p content.id
      link = content.links.find_by(url: video.external_url) ||
          Link.create(content: content, site: site, url: video.external_url)

      content.video_files << video unless content.video_files.include?(video)
      content.sites << site unless content.sites.include?(site)
      content.links << link unless content.links.include?(link)
    end
    '-'
  end

end
