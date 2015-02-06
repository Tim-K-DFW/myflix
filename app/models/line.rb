class Line < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :video, scope: :user
  # validates_uniqueness_of :priority, scope: :user
  validates :priority, numericality: { only_integer: true }

  def score # score of a user-specific video review
    review = self.video.reviews.where(author: self.user).first
    review.score if review
  end

  def self.update_queue(user_id, new_order)
    begin
      Line.transaction do
        new_order.each do |item|
          entry = Line.find(item[:id])
          entry.update_attributes!(priority: item[:new_position]) if entry.user == User.find(user_id)
        end
      end
    rescue
    end
    User.find(user_id).bump_up_queue
  end

end