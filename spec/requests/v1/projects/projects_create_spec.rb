require 'rails_helper'

RSpec.describe "Projects Create API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    context 'with valid params' do
      it 'creates a new project' do
        project_params = { title: "New project", desc: "Some long desc" }
        v1_auth_post user, projects_path, params: { project: project_params }

        expect(response.status).to eq 200
        expect_json(title: "New project", desc: "Some long desc")
        expect_json_types project_json
      end
    end

    context 'with invalid params' do
      it 'fails to create a new project (no params)' do
        v1_auth_post user, projects_path
        expect_http_error 422
      end

      it 'fails to create a new project (title missing)' do
        v1_auth_post user, projects_path, params: { project: {desc: 'description only'} }
        expect_http_error 422
      end

      it 'fails to create a new project (title over 80 chars)' do
        v1_auth_post user, projects_path, params: { project: {title: 'a' * 81} }
        expect_http_error 422
      end

      it 'fails to create a new project (desc over 300 chars)' do
        v1_auth_post user, projects_path, params: { project: {title: 'title', desc: 'a' * 301} }
        expect_http_error 422
      end
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_post projects_path
      expect_http_error 401
    end
  end
end
