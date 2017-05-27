require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should have_db_column :name }
  it { should have_db_column :desc }
  it { should have_db_column :deadline }
  it { should have_db_column :project_id }
  it { should have_db_column :position }

  it { should respond_to :name }
  it { should respond_to :desc }
  it { should respond_to :deadline }
  it { should respond_to :project }
  it { should respond_to :position }

  it { should validate_presence_of :name }
  it { should validate_length_of(:name).is_at_most(80) }

  it { should validate_length_of(:desc).is_at_most(300) }

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

  describe 'before_save:' do
    it 'increments task prosition inside project upon creation' do
      project_1 = FactoryGirl.create :project
      tasks_1 = FactoryGirl.build_list :task, 3, project: project_1
      project_2 = FactoryGirl.create :project
      tasks_2 = FactoryGirl.build_list :task, 2, project: project_2

      expect{ tasks_1.first.save }.to change{ tasks_1.first.position }.to(1)
      expect{ tasks_1.second.save }.to change{ tasks_1.second.position }.to(2)
      expect{ tasks_2.first.save }.to change{ tasks_2.first.position }.to(1)
      expect{ tasks_1.third.save }.to change{ tasks_1.third.position }.to(3)
      expect{ tasks_2.second.save }.to change{ tasks_2.second.position }.to(2)
    end

    context 'updates all project`s tasks correctly if current task`s position changed' do
      before do
        @project = FactoryGirl.create :project
        @tasks = FactoryGirl.build_list :task, 6, project: @project
        @tasks.each { |t| t.save } # set correct initial positions 1 -> 6
        @expect_correct_list = lambda do
          for i in 1..6 do
            expect(@project.tasks.find_by(position: i)).not_to be(nil), "#{i} is nil"
          end
        end
      end

      it 'position 2 -> position 5' do
        moved = @project.tasks.find_by(position: 2)
        moved.update(position: 5)
        @expect_correct_list.call
      end

      it 'position 5 -> position 2' do
        moved = @project.tasks.find_by(position: 5)
        moved.update(position: 2)
        @expect_correct_list.call
      end

      it 'position 1 -> position 6' do
        moved = @project.tasks.find_by(position: 1)
        moved.update(position: 6)
        @expect_correct_list.call
      end

      it 'position 6 -> position 1' do
        moved = @project.tasks.find_by(position: 6)
        moved.update(position: 1)
        @expect_correct_list.call
      end
    end
  end
end
