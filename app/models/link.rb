class Link < ActiveRecord::Base
  belongs_to :site
  belongs_to :content
  has_many :downloads
  validates :url, presence: { strict: true }, uniqueness: { strict: true }

  def self.find_site(url)
    Site.all.each do |site|
      return site if url.include?(site.name)
    end
    return nil
  end
end
