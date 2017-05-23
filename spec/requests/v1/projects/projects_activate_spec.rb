require 'rails_helper'

RSpec.describe "Projects Activate API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    it 'activates user`s project' do
      project = user.projects.first
      project.archive!

      v1_auth_patch user, activate_project_path(project)

      expect(response.status).to eq 200
      expect(user.projects.first).to be_in_active
    end

    it 'does not allow activatin other user`s project' do
      other_project = other_user.projects.first
      other_project.archive!

      v1_auth_patch user, activate_project_path(other_project)

      expect_http_error 404
      expect(other_user.projects.first).to be_in_acrhived
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_patch activate_project_path(user.projects.first)
      expect_http_error 401
    end
  end
end
