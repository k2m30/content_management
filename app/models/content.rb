class Content < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :sites, through: :links
  has_many :video_files, dependent: :destroy
  validates :name, presence: true

  include PgSearch
  pg_search_scope :search, against: [:name], using: {tsearch: {dictionary: :russian} }, ignoring: :accents

  def self.text_search(query)
    query.present? ? search(query) : all
  end
end
