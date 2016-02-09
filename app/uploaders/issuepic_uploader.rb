# encoding: utf-8

class IssuepicUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog

  process resize_to_fit: [500, 500]

  def filename
     "#{SecureRandom.hex(10)}.#{file.extension}" if original_filename.present?
  end

  def store_dir
    "uploads"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
