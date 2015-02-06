class Line < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :video, scope: :user
  # validates_uniqueness_of :priority, scope: :user
  validates :priority, numericality: { only_integer: true }

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

  def self.update_queue(user_id, new_order)  # add manual check for swap
    begin
      Line.transaction do
        new_order.each do |item|
          entry = Line.where(user_id: user_id, priority: item.first).first
          entry.priority = item.last
          swap_entry = Line.where(user_id: user_id, priority: item.last).first
          # binding.pry
          if swap_entry
            swap_entry.priority = -1
            swap_entry.save!
            entry.save!
            swap_entry.priority = item.first
            swap_entry.save!
          else
            entry.save!
          end
        end
      end
    rescue
    end
    Line.bump_up(user_id)
  end

end