require 'rails_helper'

RSpec.describe "Projects Show API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    it 'returns the project with list of tasks' do
      v1_auth_get user, project_path(user.projects.first)
      
      expect(response.status).to eq 200
      expect_json_types project_json
      expect_json_types 'tasks.*', task_json
      expect_json_types 'tasks.*.comments.*', comment_json
    end

    it 'returns 404: Not Found when accessing others project' do
      v1_auth_get user, project_path(other_user.projects.first)
      expect_http_error 404
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_get project_path(user.projects.first)
      expect_http_error 401
    end
  end
end
