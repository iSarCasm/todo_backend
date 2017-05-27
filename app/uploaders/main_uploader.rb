class MainUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{secure_dir_token}"
  end

  def filename
     "#{secure_file_token(10)}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_dir_token(length=8)
    (Digest::SHA256.hexdigest model.id.to_s).first length
  end

  def secure_file_token(length=16)
    SecureRandom.hex(length/2)
  end
end
