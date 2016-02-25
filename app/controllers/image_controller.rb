class ImageController < ApplicationController
  def create_from_upload(img)
    uploader = IssuepicUploader.new
    uploader.store!(img)
    img_upload = Image.create!(:url => uploader.url)
    img_upload
  end
end
