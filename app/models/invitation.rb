class Invitation < ActiveRecord::Base
  belongs_to :user
  validates :friend_name, presence: true, length: {in: 3..50}
  validates :friend_email, presence: true
  validates :message, presence: true, length: {in: 5..1000}

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
