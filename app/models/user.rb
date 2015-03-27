class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, length: {minimum: 4}
  validates :email, presence: true, length: {minimum: 3}
  has_secure_password validations: false
  has_many :reviews
  has_many :lines
  has_many :videos, through: :lines

  has_many :following_relations, class_name: 'Following', foreign_key: 'follower_id'
  has_many :leading_relations, class_name: 'Following', foreign_key: 'leader_id'

  has_many :invitations

  def bump_up_queue
    users_queue = self.lines.order('priority ASC')
    (1..users_queue.size).each do |position|
      users_queue[position - 1].update_attributes(priority: position)
    end
  end

  def follows?(another_user)
    following_relations.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !follows?(another_user) && self != another_user
  end

  def generate_token
    update(token: SecureRandom.urlsafe_base64)
    token
  end

  def connect_with_inviter(inviter)
    Following.create(leader: inviter, follower: self)
    Following.create(leader: self, follower: inviter)
  end
end