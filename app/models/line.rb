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

  def self.update_queue(user_id, args)
    update_queue_positions(user_id, args[:new_positions])
    update_ratings(user_id, args[:new_ratings])
    User.find(user_id).bump_up_queue
  end

  private

  def self.update_queue_positions(user_id, new_order)
    begin
      Line.transaction do
        new_order.each do |item|
          entry = Line.find(item[:id])
          entry.update_attributes!(priority: item[:new_position]) if entry.user == User.find(user_id)
        end
      end
    rescue
    end
  end

  def self.update_ratings(user_id, new_ratings)
    new_ratings.each do |item|
      this_video = Line.find(item[:id]).video
      review = this_video.reviews.select{|review| review[:user_id] == user_id}.first
      if !review.nil?
        review.update_attributes(score: item[:new_rating]) unless item[:new_rating].blank?
        review.save(:validate => false)
           
      else
        review = Review.new(video: this_video, author: User.find(user_id), score: item[:new_rating])
        review.save(:validate => false)
     
      end
    end
  end
end