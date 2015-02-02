class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.integer :user_id, :video_id, :priority
    end
  end
end