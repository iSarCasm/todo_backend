FactoryGirl.define do
  factory :user do
    uid                 { Faker::Number.number(12) }
    name                { Faker::Name.name }
    sequence(:email)    { |n| n.to_s + Faker::Internet.email }
    password            { Faker::Internet.password(8) }
    confirmed_at        { Time.zone.now }
  end
end
