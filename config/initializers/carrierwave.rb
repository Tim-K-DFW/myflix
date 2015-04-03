CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.storage :fog 
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ID'],
      aws_secret_access_key: ENV['AWS_KEY']
    }
    config.fog_directory  = 'tealeaftraining/myflix/covers'
    config.fog_public     = false
  else
    config.storage :file
    config.enable_processing = Rails.env.development?
  end
end
