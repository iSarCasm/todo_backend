require 'rails_helper'

RSpec.describe "Tasks API", type: :request, version: :v1 do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  describe '#create' do
    context 'when logged in' do
      context 'with valid params' do
        it 'creates a new task' do
          time = DateTime.now.to_s
          task_params = { name: "New task", desc: "Some long description", deadline: time }
          auth_post user,
                    tasks_path,
                    params: { project_id: user.projects.first.id, task: task_params, format: :json},
                    headers: v1_headers

          expect(response.status).to eq 200
          expect_json(name: "New task", desc: "Some long description", deadline: time)
        end
      end

      context 'with invalid params' do
        it 'fails to create a new task' do
          auth_post user, tasks_path, params: { format: :json }, headers: v1_headers

          expect(response.status).to eq 422
          expect(json).to include 'errors'
          expect(json).to_not include 'name'
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        post tasks_path, params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'name'
      end
    end
  end

  describe '#update' do
    context 'when logged in' do
      context 'with valid params' do
        before do
          @task_params = { name: "New task name" }
        end

        it 'updates the task' do
          auth_patch user, task_path(user.projects.first.tasks.first), params: { task: @task_params, format: :json }, headers: v1_headers

          expect(response.status).to eq 200
          expect_json(name: "New task name")
          expect_json_types(name: :string, desc: :string, deadline: :string)
        end

        context 'editing other user`s project' do
          it 'returns 403: Forbidden when accessing others task' do
            auth_patch user, task_path(other_user.projects.first.tasks.first), params: { task: @task_params, format: :json }, headers: v1_headers

            expect(response.status).to eq 403
            expect(json).to include 'errors'
            expect(json).to_not include 'name'
          end
        end
      end

      context 'with invalid params' do
        it 'fails to update the task' do
          auth_patch user, task_path(user.projects.first.tasks.first), params: { format: :json }, headers: v1_headers

          expect(response.status).to eq 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        patch project_path(user.projects.first.tasks.first), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'name'
      end
    end
  end
end
