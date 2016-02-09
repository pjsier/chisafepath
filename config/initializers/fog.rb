CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     Rails.application.secrets.AWS_ACCESS_KEY_ID,
    aws_secret_access_key: Rails.application.secrets.AWS_SECRET_ACCESS_KEY
  }
  config.fog_directory  = 'chisafepath'
end
