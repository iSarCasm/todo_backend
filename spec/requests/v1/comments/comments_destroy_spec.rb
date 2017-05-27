require 'rails_helper'

RSpec.describe "Comments Destroy API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:task) { user.tasks.first }
  let(:comment) { task.comments.first }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }
  let(:other_task) { other_user.tasks.first }
  let(:other_comment) { other_task.comments.first }

  context 'when logged in' do
    it 'destroys user`s comments' do
      comment = FactoryGirl.create :comment, user: user
      v1_auth_delete user, comment_path(comment)

      expect(response.status).to eq 200
      expect_json_types comment_json
      expect(Comment.exists?(comment.id)).to be_falsey
    end

    it 'returns 404 if wrong id given' do
      v1_auth_delete user, comment_path(-10)
      expect_http_error 404
    end

    context 'placed on other`s task' do
      it 'does not allow destroying other user`s comments' do
        other_task = FactoryGirl.create :task
        comment = FactoryGirl.create :comment, user: other_user
        comment.task = other_task

        v1_auth_delete user, comment_path(comment)

        expect_http_error 403
        expect(Comment.exists?(comment.id)).to be_truthy
      end
    end

    context 'placed on my task' do
      it 'allow destroying other user`s comments' do
        current_user = FactoryGirl.create :user_with_projects
        other_user_comment = FactoryGirl.create :comment, task: current_user.tasks.first

        v1_auth_delete current_user, comment_path(other_user_comment)

        expect(response.status).to eq 200
        expect(Comment.exists?(other_user_comment.id)).to be_falsey
      end
    end
  end

  context 'when logged out' do
    it 'return 401: Unauthorized' do
      user = FactoryGirl.create :user_with_comments
      v1_delete comment_path(user.comments.first)
      expect_http_error 401
    end
  end
end
