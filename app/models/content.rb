class Content < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :sites, through: :links
  validates :url, presence: { strict: true }, uniqueness: { strict: true }
  validates :name, presence: { strict: true }, uniqueness: { strict: true }
end
