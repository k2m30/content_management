require 'open-uri'
require 'nokogiri'

class Site < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :contents, through: :links
  validates :name, presence: true, uniqueness: true

  def standard?
    self.name == 'kinopoisk.ru' ? true : false
  end
end
