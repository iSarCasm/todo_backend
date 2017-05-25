require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_db_column :email }
  it { should have_db_column :name }
  it { should have_db_column :avatar }

  it { should respond_to :email }
  it { should respond_to :name }
  it { should respond_to :avatar }

  it { should validate_presence_of :name }

  it { should have_many(:projects).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  describe '#tasks' do
    it 'returns all tasks from all user projects' do
      user = FactoryGirl.create :user
      user_project_1 = FactoryGirl.create :project, user: user
      user_project_2 = FactoryGirl.create :project, user: user
      user_tasks_1 = FactoryGirl.create_list :task, 3, project: user_project_1
      user_tasks_2 = FactoryGirl.create_list :task, 2, project: user_project_2
      other_tasks = FactoryGirl.create_list :task, 7

      expect(user.tasks.count).to eq (user_tasks_1 + user_tasks_2).count
    end
  end

  describe '#shared_projects' do
    it 'returns all shared projects of this user' do
      user = FactoryGirl.create :user
      projects = FactoryGirl.create_list :project_shared, 3, user: user

      expect(user.shared_projects.count).to eq projects.count
    end
  end
end
