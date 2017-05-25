require 'rails_helper'

describe AttachmentUploader do
  include CarrierWave::Test::Matchers

  let(:comment) { FactoryGirl.create :comment }
  let(:uploader) { AttachmentUploader.new(comment, :attachment) }

  before do
    AttachmentUploader.enable_processing = true
    File.open("#{Rails.root}/spec/support/images/user.png") { |f| uploader.store!(f) }
  end

  after do
    AttachmentUploader.enable_processing = false
    uploader.remove!
  end

  it "has the correct format" do
    expect(uploader).to be_format('png')
  end
end
