require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_db_column :title }
  it { should have_db_column :user_id }
  it { should have_db_index :user_id }

  it { should respond_to :title }
  it { should respond_to :user }
  it { should respond_to :shared_project }
  it { should respond_to :shared? }

  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_most(80) }

  it { should validate_length_of(:desc).is_at_most(300) }

  it { should belong_to :user }
  it { should have_many(:tasks).dependent(:destroy) }
  it { should have_one(:shared_project).dependent(:destroy) }

  it { should have_state :in_active }
  it { should transition_from(:in_active).to(:in_acrhived).on_event(:archive) }
  it { should transition_from(:in_acrhived).to(:in_active).on_event(:activate) }

  describe '#shared?' do
    it 'returns TRUE if exists shared_project for this project' do
      project = FactoryGirl.create :project_shared
      expect(project.shared?).to eq true
    end

    it 'returns FALSE if no shared_project exists for this project' do
      project = FactoryGirl.create :project
      expect(project.shared?).to eq false
    end
  end
end
