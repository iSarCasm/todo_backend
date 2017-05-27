require 'rails_helper'

RSpec.describe "Comments Update API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_comments) }
  let(:comment) { user.comments.first }
  let(:comment_with_attachments) { FactoryGirl.create :comment_with_attachments, user: user }
  let(:other_user) { FactoryGirl.create(:user_with_comments) }
  let(:other_comment) { other_user.comments.first }

  context 'when logged in' do
    context 'with valid params' do
      before do
        @comment_params = { content: "New content" }
      end

      it 'updates the comment' do
        v1_auth_patch user, comment_path(comment), params: { comment: @comment_params  }

        expect(response.status).to eq 200
        expect_json(content: "New content")
        expect_json_types comment_json
      end

      it 'can remove attachments' do
        v1_auth_patch user, comment_path(comment_with_attachments), params: { comment: { attachments: [nil] } }

        expect(response.status).to eq 200
        expect(json['attachments']).to be_empty
        expect_json_types comment_json
      end

      it 'can add more attachments' do
        attachments = [
          comment_with_attachments.attachments.first,
          comment_with_attachments.attachments.second,
          Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec/support/images/user.png')))
        ]

        v1_auth_patch user, comment_path(comment_with_attachments), params: { comment: { attachments: attachments } }

        expect(response.status).to eq 200
        expect(json['attachments'].count).to eq 3
        expect(json['attachments'][0]).not_to eq nil
        expect(json['attachments'][1]).not_to eq nil
        expect(json['attachments'][2]).not_to eq nil
        expect_json_types comment_json
      end

      it 'returns 404 if wrong id given' do
        v1_auth_patch user, comment_path(-10), params: { comment: @comment_params  }
        expect_http_error 404
      end

      context 'editing other user`s comment' do
        it 'returns 403: Forbidden when accessing others comment' do
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

      it 'fails if content length over 400 char' do
        v1_auth_patch user, comment_path(comment), params: { comment: {content: 'a'*401} }
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
