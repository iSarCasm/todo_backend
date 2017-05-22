require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should have_db_column :content }

  it { should respond_to :content }

  it { should validate_presence_of :content }

  it { should belong_to :user }
  it { should belong_to :task }
end
