require 'rails_helper'

RSpec.describe SharedProject, type: :model do
  it { should have_db_column :project_id }
  it { should have_db_column :url }
  it { should have_db_index :url }

  it { should respond_to :project }
  it { should respond_to :url }

  it { should validate_uniqueness_of :url }

  it 'validates uniqueness of project_id' do
    project_1 = FactoryGirl.create :project
    FactoryGirl.create :shared_project, project: project_1

    expect{SharedProject.create!(project: project_1)}.to raise_error{ActiveRecord::RecordInvalid}
  end

  it { should belong_to :project }

  describe '#user' do
    it 'returns project owner' do
      project = FactoryGirl.create :project
      shared_project = SharedProject.create!(project: project)
      expect(shared_project.user).to eq project.user
    end
  end

  describe 'before_save:' do
    it 'sets @url' do
      project = FactoryGirl.create :project
      shared_project = SharedProject.create!(project: project)
      expect(shared_project.url).not_to be nil
    end
  end
end
