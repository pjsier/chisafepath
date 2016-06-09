CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     Rails.application.secrets.aws_access_key_id,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key
  }
  config.fog_directory  = 'chisafepath'
end
