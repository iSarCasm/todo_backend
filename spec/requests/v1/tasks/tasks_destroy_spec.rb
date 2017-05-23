require 'rails_helper'

RSpec.describe "Tasks Destroy API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    it 'destroys user`s task' do
      task = user.projects.first.tasks.first

      v1_auth_delete user, task_path(task)

      expect(response.status).to eq 200
      expect(Task.exists?(task.id)).to be_falsey
    end

    it 'returns 404: Not Found if wrong id specified' do
      v1_auth_delete user, task_path(-10)
      expect_http_error 404
    end

    it 'does not allow destroying other user`s task' do
      other_task = other_user.projects.first.tasks.first

      v1_auth_delete user, task_path(other_task)

      expect_http_error 403
      expect(Task.exists?(other_task.id)).to be_truthy
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      task = user.projects.first.tasks.first

      v1_delete task_path(task)

      expect_http_error 401
    end
  end
end
