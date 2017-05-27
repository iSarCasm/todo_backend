FactoryGirl.define do
  factory :project do
    title { Faker::Hipster.words(3).join(" ") }
    desc  { Faker::Hipster.paragraph.first(300) }
    user

    factory :project_with_tasks do
      after(:build) do |project, evaluator|
        create_list(:task_with_comments, 3, project: project)
      end
    end

    factory :project_shared do
      after(:build) do |project, evaluator|
        create :shared_project, project: project
      end
    end
  end
end
