class Line < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :video, scope: :user
  validates_uniqueness_of :priority, scope: :user

  def score
    review = self.video.reviews.where(author: self.user).first
    review.score if review
  end
end