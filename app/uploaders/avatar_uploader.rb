class AvatarUploader < MainUploader
  include CarrierWave::MiniMagick

  storage :file

  def default_url(*args)
    "/uploads/#{model.class.to_s.underscore}/fallback/default.png"
  end

  version :normal do
    process :resize_to_fit => [96, 128]
  end

  version :small do
    process :resize_to_fit => [64, 64]
  end
end
