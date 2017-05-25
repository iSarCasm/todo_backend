FactoryGirl.define do
  factory :user do
    name                  { Faker::Name.first_name }
    sequence(:email)      { |n| n.to_s + Faker::Internet.email }
    password              { Faker::Internet.password(8) }
    password_confirmation { "#{password}" }
    confirmed_at          { Time.zone.now }

    factory :user_with_projects do
      after(:create) do |user, evaluator|
        create_list(:project_with_tasks, 3, user: user)
      end
    end

    factory :user_with_comments do
      after(:create) do |user|
        create_list(:comment, 3, user: user)
      end
    end

    factory :user_with_image do
      transient do
        file_path File.join(Rails.root, 'spec/support/images/user.png')
      end

      avatar do
        Rack::Test::UploadedFile.new(File.open(file_path))
      end
    end
  end
end
