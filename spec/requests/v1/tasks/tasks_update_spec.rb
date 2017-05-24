require 'rails_helper'

RSpec.describe "Tasks Update API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    context 'with valid params' do
      before do
        @task_params = { name: "New task name" }
      end

      it 'updates the task' do
        v1_auth_patch user, task_path(user.tasks.first), params: { task: @task_params }

        expect(response.status).to eq 200
        expect_json(name: "New task name")
        expect_json_types(name: :string, desc: :string, deadline: :string)
      end

      it 'returns 404: Not Found if wrong id specified' do
        v1_auth_patch user, task_path(-10), params: { task: @task_params }
        expect_http_error 404
      end

      context 'editing other user`s task' do
        it 'returns 404: Not Found when accessing others task' do
          v1_auth_patch user, task_path(other_user.tasks.first), params: { task: @task_params }
          expect_http_error 404
        end
      end
    end

    context 'with invalid params' do
      it 'fails to update the task' do
        v1_auth_patch user, task_path(user.tasks.first)
        expect_http_error 422
      end
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      task = user.tasks.first

      v1_patch task_path(task)

      expect_http_error 401
    end
  end
end
