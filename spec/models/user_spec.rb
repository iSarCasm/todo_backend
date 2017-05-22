require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_db_column :email }
  it { should have_db_column :name }
  it { should have_db_column :image }

  it { should respond_to :email }
  it { should respond_to :name }
  it { should respond_to :image }

  it { should validate_presence_of :name }

  it { should have_many(:projects) }
end
