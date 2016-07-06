class ImageCleanupJob < ActiveJob::Base
  queue_as :default

  def perform
    Image.where("created_at <= ?", 2.days.ago).map{ |i|
      i.remove_aws_img
    }
  end
end
