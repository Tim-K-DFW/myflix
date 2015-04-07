class AddUploadersToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :small_cover_upload, :string
    add_column :videos, :large_cover_upload, :string
  end
end
