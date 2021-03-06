require 'rails_helper'

RSpec.describe "Tasks Create API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    context 'with valid params' do
      it 'creates a new task' do
        time = DateTime.now.strftime("%Y-%m-%d")
        task_params = { name: "New task", desc: "Some long description", deadline: time }

        v1_auth_post user,
                  tasks_path,
                  params: { project_id: user.projects.first.id, task: task_params}
        
        expect(response.status).to eq 200
        expect_json(name: "New task", desc: "Some long description", deadline: time)
        expect_json_types task_json
      end
    end

    context 'with invalid params' do
      it 'fails to create a new task without params' do
        v1_auth_post user, tasks_path
        expect_http_error 404
      end

      it 'fails to create a new task without task params' do
        v1_auth_post user, tasks_path, params: { project_id: user.projects.first.id }
        expect_http_error 422
      end

      it 'fails to create a new task (no name)' do
        v1_auth_post user, tasks_path, params: { project_id: user.projects.first.id, task: {} }
        expect_http_error 422
      end

      it 'fails to create a new task (name over 80 char)' do
        v1_auth_post user, tasks_path, params: { project_id: user.projects.first.id, task: {name: 'a' * 81} }
        expect_http_error 422
      end

      it 'fails to create a new task (desc over 300 char)' do
        v1_auth_post user, tasks_path, params: { project_id: user.projects.first.id, task: {name: 'a', desc: 'a' * 301} }
        expect_http_error 422
      end
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_post tasks_path
      expect_http_error 401
    end
  end
end
