class LargeCoverUploader < CoverUploader
  process :resize_to_fit => [665, 375]

  def filename
    "#{model.title.underscore.gsub(' ', '_')}_cover_large.jpg" if original_filename
  end
end
