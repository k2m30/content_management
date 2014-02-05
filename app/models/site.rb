class Site < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :contents, through: :links
  validates :name, presence: true, uniqueness: true
end
