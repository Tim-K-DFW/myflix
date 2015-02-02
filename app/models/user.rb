class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true, length: {minimum: 4}
  validates :password, presence: true, length: {minimum: 3}
  validates :email, presence: true, length: {minimum: 3}
  has_secure_password validations: false
  has_many :reviews
  has_many :lines
  has_many :videos, through: :lines
end