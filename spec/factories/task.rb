FactoryGirl.define do
  factory :task do
    name        { Faker::Hipster.word }
    desc        { Faker::Hipster.paragraph.first(300) }
    deadline    { Faker::Time.forward(23, :morning) }
    project

    factory :task_with_comments do
      after(:build) do |task, evaluator|
        create_list(:comment, 3, task: task)
      end
    end
  end
end
