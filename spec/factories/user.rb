FactoryGirl.define do
  factory :user do
    uid                 { Faker::Number.number(12) }
    name                { Faker::Name.name }
    sequence(:email)    { |n| n.to_s + Faker::Internet.email }
    password            { Faker::Internet.password(8) }
    confirmed_at        { Time.zone.now }

    factory :user_with_projects do
      after(:create) do |user, evaluator|
        create_list(:project_with_tasks, 3, user: user)
      end
    end
  end
end
