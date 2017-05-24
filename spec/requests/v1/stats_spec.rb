require 'rails_helper'

RSpec.describe "Stats API", type: :request do
  describe '#index' do
    it 'returns the user with list of projects' do
      FactoryGirl.create :user_with_projects

      v1_get stats_path

      expect(response.status).to eq 200
      expect_json(users: User.count, projects: Project.count, tasks: Task.count, comments: Comment.count)
      expect_json_types(stats_json)
    end
  end
end
