class Invitation < ActiveRecord::Base
  belongs_to :user

  # validates_presense_of :friend_name, :friend_email, :message

  validates :friend_name, presence: true, length: {in: 3..50}
end
