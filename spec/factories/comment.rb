FactoryGirl.define do
  factory :comment do
    content { Faker::Hipster.paragraph }
    task
    user
  end
end
