class Site < ActiveRecord::Base
  has_many :links
  has_many :contents, through: :links
end
