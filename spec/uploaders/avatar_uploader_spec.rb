require 'rails_helper'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let(:user) { FactoryGirl.create :user }
  let(:uploader) { AvatarUploader.new(user, :avatar) }

  before do
    AvatarUploader.enable_processing = true
    File.open("#{Rails.root}/spec/support/images/default.png") { |f| uploader.store!(f) }
  end

  after do
    AvatarUploader.enable_processing = false
    uploader.remove!
  end

  context 'the small version' do
    it "scales down a landscape image to be exactly 64 by 64 pixels" do
      expect(uploader.small).to be_no_larger_than(64, 64)
    end
  end

  context 'the normal version' do
    it "scales down a landscape image to fit within 96 by 128 pixels" do
      expect(uploader.normal).to be_no_larger_than(96, 128)
    end
  end

  it "has the correct format" do
    expect(uploader).to be_format('png')
  end
end
