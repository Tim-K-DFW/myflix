class Video < ActiveRecord::Base
  belongs_to :category
  has_many :lines
  has_many :users, through: :lines
  validates_presence_of :title, :description
  has_many :reviews, -> { order("created_at DESC") }

  mount_uploader :small_cover_upload, SmallCoverUploader
  mount_uploader :large_cover_upload, LargeCoverUploader

  def self.search_by_title(str)
    str.blank? ? [] : where('title ILIKE ?', "%#{str}%").order('created_at DESC')
  end

  def average_score
    all_scores  = []
    self.reviews.each {|review| all_scores << review.score}
    all_scores.blank? ? 0 : (all_scores.inject{|sum, el| sum + el}.to_f / all_scores.size).round(1)
  end
end