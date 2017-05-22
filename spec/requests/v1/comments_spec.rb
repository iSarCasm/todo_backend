require 'rails_helper'

RSpec.describe "Comments API", type: :request, version: :v1 do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:other_user) { FactoryGirl.create(:user_with_projects) }
  let(:comment) { user.projects.first.tasks.first.comments.first }
  let(:other_comment) { other_user.projects.first.tasks.first.comments.first }

  describe '#create' do
    context 'when logged in' do
      context 'with valid params' do
        it 'creates a new comment' do
          time = DateTime.now.to_s
          comment_params = { content: "Some comment about something" }
          auth_post user,
                    comments_path,
                    params: { task_id: user.projects[0].tasks[0].id, comment: comment_params, format: :json},
                    headers: v1_headers

          expect(response.status).to eq 200
          expect_json(content: "Some comment about something")
        end
      end

      context 'with invalid params' do
        it 'fails to create a new comment' do
          auth_post user, comments_path, params: { format: :json }, headers: v1_headers

          expect(response.status).to eq 422
          expect(json).to include 'errors'
          expect(json).to_not include 'content'
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        post comments_path, params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'content'
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
          auth_patch user, comment_path(comment), params: { comment: @comment_params, format: :json }, headers: v1_headers

          expect(response.status).to eq 200
          expect_json(content: "New content")
        end

        context 'editing other user`s comment' do
          it 'returns 403: Forbidden when accessing others task' do
            auth_patch user, comment_path(other_comment), params: { comment: @comment_params, format: :json }, headers: v1_headers

            expect(response.status).to eq 403
            expect(json).to include 'errors'
            expect(json).to_not include 'name'
          end
        end
      end

      context 'with invalid params' do
        it 'fails to update the comment' do
          auth_patch user, comment_path(comment), params: { format: :json }, headers: v1_headers

          expect(response.status).to eq 422
        end
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        patch comment_path(comment), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'name'
      end
    end
  end
end
