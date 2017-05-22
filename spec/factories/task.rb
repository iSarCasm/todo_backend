FactoryGirl.define do
  factory :task do
    name        { Faker::Hipster.word }
    desc        { Faker::Hipster.paragraph }
    deadline    { Faker::Time.forward(23, :morning) }
    project

    factory :task_with_comments do
      after(:create) do |task, evaluator|
        create_list(:comment, 3, task: task)
      end
    end
  end
end
