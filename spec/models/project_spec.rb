require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_db_column :title }
  it { should have_db_column :user_id }
  it { should have_db_index :user_id }

  it { should respond_to :title }
  it { should respond_to :user }

  it { should belong_to :user }
  it { should have_many(:tasks).dependent(:destroy) }

  it { should have_state :in_active }
  it { should transition_from(:in_active).to(:in_acrhived).on_event(:archive) }
  it { should transition_from(:in_acrhived).to(:in_active).on_event(:activate) }
end
