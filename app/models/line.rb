class Line < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :video, scope: :user
  # validates_uniqueness_of :priority, scope: :user
  validates :priority, numericality: { only_integer: true }

  def score # score of a user-specific video review
    review.score if review
  end

  def score=(new_score)
    if review
      review.update_column(:score, new_score)
    else
      new_review = Review.create(score: new_score, author: self.user, video: self.video)
      new_review.save(validate: false)
    end
  end

  def self.update_queue(user_id, args)
    begin
      Line.transaction do
        args.each do |item|
          entry = Line.find(item[:id])
          entry.update_attributes!(priority: item[:new_position]) if entry.user == User.find(user_id)
          entry.score = item[:new_rating]
        end
      end
    rescue
    end
    User.find(user_id).bump_up_queue
  end

  private

  def review
    @review ||= Review.where(user_id: self.user.id, video: self.video).first
  end

end