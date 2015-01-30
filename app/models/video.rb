class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description
  has_many :reviews, -> { order("created_at DESC") }

  def self.search_by_title(str)
    str.blank? ? [] : where('title ILIKE ?', "%#{str}%").order('created_at DESC')
  end

  def average_score
    all_scores  = []
    self.reviews.each {|review| all_scores << review.score}
    all_scores.blank? ? 0 : (all_scores.inject{|sum, el| sum + el}.to_f / all_scores.size).round(1)
  end
end