require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should have_db_column :content }

  it { should respond_to :content }

  it { should validate_presence_of :content }

  it { should belong_to :user }
  it { should belong_to :task }

  describe '#task_owner' do
    it 'returns User who owns task on which comment is published' do
      task_owner = FactoryGirl.create :user_with_projects
      task = FactoryGirl.create :task, project: task_owner.projects.first
      comment = FactoryGirl.create :comment, task: task

      expect(comment.task_owner).to eq task_owner
    end
  end

  describe '#owner, #author' do
    it 'returns comment owner' do
      user = FactoryGirl.create :user
      comment = FactoryGirl.create :comment, user: user

      expect(comment.owner).to eq user
      expect(comment.author).to eq user
    end
  end
end
