class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, length: {minimum: 4}
  validates :password, presence: true, length: {minimum: 3}
  validates :email, presence: true, length: {minimum: 3}
  has_secure_password validations: false
  has_many :reviews
  has_many :lines
  has_many :videos, through: :lines

  has_many :following_relations, class_name: 'Following', foreign_key: 'follower_id'
  has_many :leading_relations, class_name: 'Following', foreign_key: 'leader_id'

  def bump_up_queue
    users_queue = self.lines.order('priority ASC')
    (1..users_queue.size).each do |position|
      users_queue[position - 1].update_attributes(priority: position)
    end
  end
end