class AttachmentUploader < MainUploader
  include CarrierWave::MiniMagick

  storage :file
end
