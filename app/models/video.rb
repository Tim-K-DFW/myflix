class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description

  def self.search_by_title(str)
    str.blank? ? [] : where('title ILIKE ?', "%#{str}%").order('created_at DESC')
  end
end