class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :user
  validates :friend_name, presence: true, length: {in: 3..50}
  validates :friend_email, presence: true
  validates :message, presence: true, length: {in: 5..1000}
end
