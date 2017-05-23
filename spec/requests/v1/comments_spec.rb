require 'rails_helper'

RSpec.describe "Comments API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:task) { user.projects.first.tasks.first }
  let(:comment) { task.comments.first }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }
  let(:other_task) { other_user.projects.first.tasks.first }
  let(:other_comment) { other_task.comments.first }

  describe '#create' do
    context 'when logged in' do
      context 'with valid params' do
        before { @comment_params = { content: "Some comment about something" } }

        it 'creates a new comment' do
          v1_auth_post user,
                    comments_path,
                    params: { task_id: task.id, comment: @comment_params }

          expect(response.status).to eq 200
          expect_json(content: "Some comment about something")
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

        context 'editing other user`s comment' do
          it 'returns 403: Forbidden when accessing others task' do
            v1_auth_post user, comments_path, params: { task_id: other_task.id, comment: @comment_params }
            expect_http_error 403
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

  describe '#update' do
    context 'when logged in' do
      context 'with valid params' do
        before do
          @comment_params = { content: "New content" }
        end

        it 'updates the comment' do
          v1_auth_patch user, comment_path(comment), params: { comment: @comment_params  }

          expect(response.status).to eq 200
          expect_json(content: "New content")
        end

        it 'returns 404 if wrong id given' do
          v1_auth_patch user, comment_path(-10), params: { comment: @comment_params  }
          expect_http_error 404
        end

        context 'editing other user`s comment' do
          it 'returns 403: Forbidden when accessing others task' do
            v1_auth_patch user, comment_path(other_comment), params: { comment: @comment_params  }
            expect_http_error 403
          end
        end
      end

      context 'with invalid params' do
        it 'fails to update the comment' do
          v1_auth_patch user, comment_path(comment)
          expect_http_error 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_patch comment_path(comment)
        expect_http_error 401
      end
    end
  end

  describe '#destroy' do
    context 'when logged in' do
      it 'destroys user`s comments' do
        comment = FactoryGirl.create :comment, user: user
        v1_auth_delete user, comment_path(comment)

        expect(response.status).to eq 200
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
          current_user = FactoryGirl.create :user
          user_project = FactoryGirl.create :project, user: current_user
          user_task = FactoryGirl.create :task, project: user_project
          other_user_comment = FactoryGirl.create :comment, task: user_task

          v1_auth_delete current_user, comment_path(other_user_comment)

          expect(response.status).to eq 200
          expect(Comment.exists?(other_user_comment.id)).to be_falsey
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_delete comment_path(user.projects.first.tasks.first.comments.first)
        expect_http_error 401
      end
    end
  end
end
