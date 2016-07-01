class Image < ActiveRecord::Base
  def remove_aws_img
    if self.image_url.starts_with("https://chisafepath")
      s3 = Aws::S3::Client.new
      s3.delete_object(bucket: 'chisafepath', key: self.image_url[37..-1])
    end
  end

  def self.create_from_upload(img)
    uploader = IssuepicUploader.new
    uploader.store!(img)
    img_upload = Image.create!(:url => uploader.url)
    img_upload
  end
end
