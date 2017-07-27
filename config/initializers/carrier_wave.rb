if Rails.env.production?
  # configure resource manager to use s3 in prod
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider => 'AWS',
      :aws_access_key_id => ENV['JM_HARTL_ACCESS_KEY_ID'],
      :aws_secret_access_key => ENV['JM_HARTL_SECRET_ACCESS_KEY'],
      :region => ENV['JM_HARTL_REGION']
    }
    config.fog_directory = ENV['JM_HARTL_BUCKET']
  end
end
