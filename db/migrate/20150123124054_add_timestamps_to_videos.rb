class AddTimestampsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :created_at, :datetime
    add_column :videos, :updated_at, :datetime
    add_column :categories, :created_at, :datetime
    add_column :categories, :updated_at, :datetime
  end
end
