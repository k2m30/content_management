class Visit < ActiveRecord::Base
  belongs_to :link

  def self.stats(from=nil, to=nil)
    if from.present? && to.present?
      full_list = Visit.where(link_id: nil, time: [from..to]).pluck(:film)
    else
      full_list = Visit.where(link_id: nil).pluck(:film)
    end
    short_list = full_list.uniq

    short_list.map{|film| [film, full_list.count(film)]}.sort_by{|film| film[1]}.reverse
  end
end
