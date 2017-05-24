require 'rails_helper'

RSpec.describe Stats, type: :model do
  describe '.new' do
    it 'creates new stats representing Users, Projects, Tasks and Comments count' do
      allow(User).to receive(:count).and_return(10)
      allow(Project).to receive(:count).and_return(20)
      allow(Task).to receive(:count).and_return(30)
      allow(Comment).to receive(:count).and_return(40)

      stats = Stats.new

      expect(stats.users).to eq 10
      expect(stats.projects).to eq 20
      expect(stats.tasks).to eq 30
      expect(stats.comments).to eq 40
    end
  end
end
