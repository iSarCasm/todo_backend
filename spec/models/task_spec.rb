require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should have_db_column :name }
  it { should have_db_column :desc }
  it { should have_db_column :deadline }
  it { should have_db_column :project_id }

  it { should respond_to :name }
  it { should respond_to :desc }
  it { should respond_to :deadline }
  it { should respond_to :project }

  it { should belong_to :project }
  it { should have_many(:comments).dependent(:destroy) }

  it { should have_state :in_progess }
  it { should transition_from(:in_progess).to(:finished).on_event(:finish) }
  it { should transition_from(:finished).to(:in_progess).on_event(:to_progress) }

  describe '#user, #owner' do
    it 'return User who owns task`s project' do
      user = FactoryGirl.create :user
      project = FactoryGirl.create :project, user: user
      task = FactoryGirl.create :task, project: project

      expect(task.user).to eq user
      expect(task.owner).to eq user
    end
  end
end
