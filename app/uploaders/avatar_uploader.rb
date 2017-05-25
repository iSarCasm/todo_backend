class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{secure_dir_token}"
  end

  def default_url(*args)
    "/uploads/#{model.class.to_s.underscore}/fallback/default.png"
  end

  def filename
     "#{secure_file_token(10)}.#{file.extension}" if original_filename.present?
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

  def secure_dir_token(length=8)
    (Digest::SHA256.hexdigest model.id.to_s).first length
  end

  def secure_file_token(length=16)
    var = :"@#{mounted_as}_secure_file_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end
