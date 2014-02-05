class Link < ActiveRecord::Base
  belongs_to :site
  belongs_to :content
end
