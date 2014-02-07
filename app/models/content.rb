class Content < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :sites, through: :links
  validates :url, presence: true
  validates :name, presence: true
end
