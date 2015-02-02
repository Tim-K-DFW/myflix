class LineVideo < ActiveRecord::Base
  belongs_to :line
  belongs_to :video
  validates_uniqueness_of :video, scope: :line
  validates_uniqueness_of :priority, scope: :line
end