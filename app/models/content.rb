class Content < ActiveRecord::Base
  has_many :links
  has_many :sites, through: :links
end
