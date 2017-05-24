require 'rails_helper'

RSpec.describe "Comments Create API", type: :request do
  let(:user) { FactoryGirl.create :user_with_projects }
  let(:task) { user.tasks.first }
  let(:other_task) {  FactoryGirl.create :task }

  context 'when logged in' do
    context 'with valid params' do
      before { @comment_params = { content: "Some comment about something" } }

      it 'creates a new comment' do
        v1_auth_post user,
                  comments_path,
                  params: { task_id: task.id, comment: @comment_params }

        expect(response.status).to eq 200
        expect_json(content: "Some comment about something")
        expect_json_types comment_json
      end

      context 'with invalid params' do
        it 'returns 422 if no comment params passed' do
          v1_auth_post user, comments_path, params: { task_id: task.id }
          expect_http_error 422
        end

        it 'returns 404 if invalid task id passed' do
          v1_auth_post user, comments_path, params: { task_id: -10, comment: @comment_params }
          expect_http_error 404
        end
      end

      context 'adding to other user`s task' do
        it 'returns 404: Forbidden when accessing others task' do
          v1_auth_post user, comments_path, params: { task_id: other_task.id, comment: @comment_params }
          expect_http_error 404
        end
      end
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      v1_post comments_path
      expect_http_error 401
    end
  end
end
