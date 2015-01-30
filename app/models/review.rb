class Review < ActiveRecord::Base
  belongs_to :author, foreign_key: 'user_id', class_name: 'User'
  belongs_to :video
  validates_presence_of :body
  # validates_uniqueness_of :author, scope: :video
end