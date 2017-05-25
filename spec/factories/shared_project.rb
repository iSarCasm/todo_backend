FactoryGirl.define do
  factory :shared_project do
    url     { SecureRandom.hex(8) }
    project
  end
end
