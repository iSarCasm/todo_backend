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
end
