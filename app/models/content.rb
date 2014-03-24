class Content < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :sites, through: :links
  has_many :video_files
  validates :url, presence: true
  validates :name, presence: true
end
