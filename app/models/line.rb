class Line < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :video, scope: :user
  validates_uniqueness_of :priority, scope: :user

  def score
    review = self.video.reviews.where(author: self.user).first
    review.score if review
  end

  def self.bump_up(user_id)
    users_queue = Line.where(user_id: user_id).order('priority ASC')
    (1..users_queue.size).each do |position|
      users_queue[position - 1].priority = position
      users_queue[position - 1].save
    end
  end
end