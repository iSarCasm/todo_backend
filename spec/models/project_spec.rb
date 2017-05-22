require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_db_column :title }
  it { should have_db_column :user_id }
  it { should have_db_index :user_id }

  it { should respond_to :title }
  it { should respond_to :user }
  
  it { should have_many(:tasks) }
end
