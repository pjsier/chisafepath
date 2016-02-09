class Issue < ActiveRecord::Base

  has_and_belongs_to_many :categories

  def remove_aws_img
    if self.image_url.starts_with("https://chisafepath")
      s3 = Aws::S3::Client.new
      s3.delete_object(bucket: 'chisafepath', key: self.image_url[37..-1])
    end
  end
end
