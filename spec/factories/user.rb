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
      after(:create) do |user, evaluator|
        create_list(:comment, 3, user: user)
      end
    end
  end
end
