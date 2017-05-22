require 'rails_helper'

RSpec.describe "Projects API", type: :request, version: :v1 do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  describe '#show' do
    context 'when logged in' do
      it 'returns the list of projects' do
        auth_get user, project_path(user.projects[0]), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 200
        expect_json_types(
          title: :string,
          tasks: :array_of_objects
        )
        expect_json_types(
          'tasks.*',
          name: :string,
          desc: :string,
          deadline: :string,
          comments: :array_of_objects
        )
        expect_json_types(
          'tasks.*.comments.*',
          content: :string,
        )
      end

      it 'returns 403: Forbidden when accessing others project' do
        auth_get user, project_path(other_user.projects[0]), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 403
        expect(json).to include 'errors'
        expect(json).to_not include 'projects'
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        get project_path(user.projects[0]), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'projects'
      end
    end
  end

  describe '#create' do
    context 'when logged in' do
      context 'with valid params' do
        it 'creates a new project' do
          project_params = { title: "New project" }
          auth_post user, projects_path, params: { project: project_params, format: :json }, headers: v1_headers

          expect(response.status).to eq 200
          expect_json(title: "New project")
        end
      end

      context 'with invalid params' do
        it 'fails to create a new project' do
          auth_post user, projects_path, params: { format: :json }, headers: v1_headers

          expect(response.status).to eq 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        post projects_path, params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'projects'
      end
    end
  end
end
