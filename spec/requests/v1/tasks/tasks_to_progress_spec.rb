require 'rails_helper'

RSpec.describe "Tasks ToProgress API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    it 'finishes user`s task' do
      task = user.projects.first.tasks.first
      task.finish!

      v1_auth_patch user, to_progress_task_path(task)

      expect(response.status).to eq 200
      expect(user.projects.first.tasks.first).to be_in_progess
    end

    it 'returns 404: Not Found if wrong id specified' do
      v1_auth_patch user, to_progress_task_path(-10)
      expect_http_error 404
    end

    it 'does not allow finishing other user`s task' do
      other_task = other_user.projects.first.tasks.first
      other_task.finish!

      v1_auth_patch user, to_progress_task_path(other_task)

      expect_http_error 403
      expect(other_user.projects.first.tasks.first).to be_finished
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_patch finish_task_path(user.projects.first.tasks.first)
      expect_http_error 401
    end
  end
end
