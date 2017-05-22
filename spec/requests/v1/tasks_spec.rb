require 'rails_helper'

RSpec.describe "Tasks API", type: :request, version: :v1 do
  let(:user) { FactoryGirl.create(:user_with_projects) }

  describe '#create' do
    context 'when logged in' do
      context 'with valid params' do
        it 'creates a new project' do
          time = DateTime.now.to_s
          task_params = { name: "New task", desc: "Some long description", deadline: time }
          auth_post user,
                    tasks_path,
                    params: { project_id: user.projects[0].id, task: task_params, format: :json},
                    headers: v1_headers

          expect(response.status).to eq 200
          expect_json(name: "New task", desc: "Some long description", deadline: time)
        end
      end

      context 'with invalid params' do
        it 'fails to create a new project' do
          auth_post user, tasks_path, params: { format: :json }, headers: v1_headers

          expect(response.status).to eq 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        post tasks_path, params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'projects'
      end
    end
  end
end
