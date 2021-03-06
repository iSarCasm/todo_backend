require 'rails_helper'

RSpec.describe "Tasks Finish API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }

  context 'when logged in' do
    it 'finishes user`s task' do
      task = user.tasks.first

      v1_auth_patch user, finish_task_path(task)

      expect(user.tasks.first).to be_finished
      expect(response.status).to eq 200
      expect_json_types task_json
    end

    it 'returns 404: Not Found if wrong id specified' do
      v1_auth_patch user, finish_task_path(-10)
      expect_http_error 404
    end

    it 'does not allow finishing other user`s task' do
      other_task = other_user.tasks.first

      v1_auth_patch user, finish_task_path(other_task)

      expect_http_error 404
      expect(other_user.tasks.first).to be_in_progess
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_patch finish_task_path(user.tasks.first)
      expect_http_error 401
    end
  end
end
