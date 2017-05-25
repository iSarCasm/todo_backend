require 'rails_helper'

RSpec.describe SharedProject, type: :model do
  it { should have_db_column :project_id }
  it { should have_db_column :url }
  it { should have_db_index :url }

  it { should respond_to :project }
  it { should respond_to :url }

  it { should validate_uniqueness_of :url }

  it { should belong_to :project }
end
