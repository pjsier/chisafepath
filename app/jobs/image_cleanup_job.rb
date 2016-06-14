class ImageCleanupJob < ActiveJob::Base
  queue_as :default

  def perform
    old_images = Image.where("created_at <= ?", 2.days.ago)
    old_images.map{ |i|
      i.remove_aws_img
      i.destroy
    }
  end
end
