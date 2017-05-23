require 'rails_helper'

RSpec.describe "Users API", type: :request, version: :v1 do
  let(:user) { FactoryGirl.create(:user_with_projects) }

  describe '#show' do
    context 'when logged in' do
      it 'returns the user with list of projects' do
        auth_get user, user_path(user.name), headers: v1_headers

        expect(response.status).to eq 200

        expect_json(uid: user.uid, name: user.name, email: user.email)
        expect_json_types(
          uid: :string,
          name: :string,
          email: :string,
          projects: :array_of_objects
        )
        expect_json_types(
          'projects.*',
          title: :string,
          tasks: :array_of_objects,
          in_active: :boolean
        )
        expect_json_types(
          'projects.*.tasks.*',
          name: :string,
          desc: :string,
          deadline: :string,
          comments: :array_of_objects,
          finished: :boolean
        )
        expect_json_types(
          'projects.*.tasks.*.comments.*',
          content: :string,
        )
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        get user_path(user.name), headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'uid'
      end
    end
  end
end
