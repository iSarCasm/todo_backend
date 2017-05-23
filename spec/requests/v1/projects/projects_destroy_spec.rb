require 'rails_helper'

RSpec.describe "Projects Destroy API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    it 'destroys user`s project' do
      project = user.projects.first
      v1_auth_delete user, project_path(project)

      expect(response.status).to eq 200
      expect(Project.exists?(project.id)).to be_falsey
    end

    it 'does not allow destroying other user`s project' do
      other_project = other_user.projects.first
      v1_auth_delete user, project_path(other_project)

      expect_http_error 404
      expect(Project.exists?(other_project.id)).to be_truthy
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_delete project_path(user.projects.first)
      expect_http_error 401
    end
  end
end
