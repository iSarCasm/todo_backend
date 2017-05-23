FactoryGirl.define do
  factory :project do
    title { Faker::Hipster.words(3).join(" ") }
    user

    factory :project_with_tasks do
      after(:build) do |project, evaluator|
        create_list(:task_with_comments, 3, project: project)
      end
    end
  end
end
