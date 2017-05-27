FactoryGirl.define do
  factory :comment do
    content { Faker::Hipster.paragraph.first(400) }
    task
    user

    factory :comment_with_attachments do
      transient do
        file_path File.join(Rails.root, 'spec/support/images/user.png')
      end

      attachments do
        [
          Rack::Test::UploadedFile.new(File.open(file_path)),
          Rack::Test::UploadedFile.new(File.open(file_path))
        ]
      end
    end
  end
end
