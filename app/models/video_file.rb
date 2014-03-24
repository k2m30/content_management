class VideoFile < ActiveRecord::Base
  belongs_to :content
  has_many :links, through: :content

  def import

  end
end
