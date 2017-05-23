require 'rails_helper'

RSpec.describe "Projects Update API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    context 'with valid params' do
      before do
        @project_params = { desc: "New long desc" }
      end

      it 'updates' do
        v1_auth_patch user, project_path(user.projects.first), params: { project: @project_params }

        expect(response.status).to eq 200
        expect_json(desc: "New long desc")
        expect_json_types(title: :string, desc: :string)
      end

      context 'editing other user`s project' do
        it 'returns 404: Not Found when accessing others project' do
          v1_auth_patch user, project_path(other_user.projects.first), params: { project: @project_params }
          expect_http_error 404
        end
      end
    end

    context 'with invalid params' do
      it 'fails to update the project' do
        v1_auth_patch user, project_path(user.projects.first)
        expect_http_error 422
      end
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_patch project_path(user.projects.first)
      expect_http_error 401
    end
  end
end
