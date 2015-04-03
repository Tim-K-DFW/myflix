class SmallCoverUploader < CoverUploader
  process :resize_to_fit => [166, 236]

  def filename
    "#{model.title.underscore.gsub(' ', '_')}_cover_small.jpg" if original_filename
  end
end
