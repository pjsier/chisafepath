# encoding: utf-8

class IssuepicUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  include CarrierWave::MiniMagick

  process convert: "png"

  def filename
    original_filename.gsub(/([\s\-_\[\]\{\}\*\']|%20)+/i, "-") if original_filename
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
