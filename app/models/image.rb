class Image < ActiveRecord::Base
  def remove_aws_img
    s3 = Aws::S3::Client.new(
      region: ENV["S3_REGION"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    )
    s3.delete_object({bucket: 'chisafepath', key: self.url[37..-1]})
    self.destroy
  end

  def self.create_from_upload(img)
    uploader = IssuepicUploader.new
    uploader.store!(img)
    img_upload = Image.create!(:url => uploader.url)
    img_upload
  end
end
