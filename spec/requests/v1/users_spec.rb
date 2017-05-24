require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let(:user) { FactoryGirl.create(:user_with_projects) }

  describe '#show' do
    context 'when logged in' do
      it 'returns the user with list of projects' do
        v1_auth_get user, user_path(user.name)

        expect(response.status).to eq 200

        expect_json(uid: user.uid, name: user.name, email: user.email)
        expect_json_types(user_json)
        expect_json_types('projects.*', project_json)
        expect_json_types('projects.*.tasks.*', task_json)
        expect_json_types('projects.*.tasks.*.comments.*', comment_json)
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        v1_get user_path(user.name)

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'uid'
      end
    end
  end
end
