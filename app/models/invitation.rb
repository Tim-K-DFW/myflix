class Invitation < ActiveRecord::Base
  belongs_to :user
  validates :friend_name, presence: true, length: {in: 3..50}
  validates :friend_email, presence: true
  validates :message, presence: true, length: {in: 5..1000}

  def generate_token
    update(token: SecureRandom.urlsafe_base64)
  end
end
