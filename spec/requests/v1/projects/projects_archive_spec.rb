require 'rails_helper'

RSpec.describe "Projects Archive API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    it 'archives user`s project' do
      project = user.projects.first

      v1_auth_patch user, archive_project_path(project)

      expect(user.projects.first).to be_in_acrhived
      expect(response.status).to eq 200
      expect_json_types project_json
    end

    it 'does not allow archiving other user`s project' do
      other_project = other_user.projects.first

      v1_auth_patch user, archive_project_path(other_project)

      expect_http_error 404
      expect(other_user.projects.first).to be_in_active
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_patch archive_project_path(user.projects.first)
      expect_http_error 401
    end
  end
end
