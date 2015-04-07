class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    'tmp/'
  end

  def cache_dir
    '/tmp/cache'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
