class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    "/uploads/#{model.class.to_s.underscore}/image/fallback/default.png"
  end

  version :normal do
    process :default_conversion => [96, 128]
  end

  version :small do
    process :default_conversion => [64, 64]
  end

  private

  def default_conversion(width, height)
    manipulate! do |img|
      img.combine_options do |c|
        c.resize "#{width}x#{height}>"
      end
      img
    end
  end
end
