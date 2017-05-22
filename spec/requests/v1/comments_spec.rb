require 'rails_helper'

RSpec.describe "Comments API", type: :request, version: :v1 do
  let(:user) { FactoryGirl.create(:user_with_projects) }

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
end
