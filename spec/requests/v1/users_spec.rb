require 'rails_helper'

RSpec.describe "Users API", type: :request, version: :v1 do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:password) { '12345' }

  describe '#show' do
    context 'when logged in' do
      it 'returns the user with list of projects' do
        auth_get user, user_path(user.name), params: { format: :json }, headers: v1_headers

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
          tasks: :array_of_objects
        )
        expect_json_types(
          'projects.*.tasks.*',
          name: :string,
          desc: :string,
          deadline: :string,
          comments: :array_of_objects
        )
        expect_json_types(
          'projects.*.tasks.*.comments.*',
          content: :string,
        )
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        get user_path(user.name), params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 401
        expect(json).to include 'errors'
        expect(json).to_not include 'uid'
      end
    end
  end

  describe '#destroy' do
    context 'when logged in' do
      context 'with valid params' do
        it 'destroys user record' do
          allow_any_instance_of(Overrides::RegistrationsController).to receive(:password_confirmed?).and_return(true)

          auth_delete user, user_registration_path, params: { password: password, format: :json}, headers: v1_headers

          expect(response.status).to eq 200
          expect{User.find(user.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'with invalid params' do
        it 'leaves user as it is if wrong password passed' do
          allow_any_instance_of(Overrides::RegistrationsController).to receive(:password_confirmed?).and_return(false)

          auth_delete user, user_registration_path, params: { password: password, format: :json }, headers: v1_headers

          expect(response.status).to eq 403
          expect(User.find(user.id)).to eq user
        end

        it 'leaves user as it is if no password passed' do
          auth_delete user, user_registration_path, params: { format: :json }, headers: v1_headers

          expect(User.find(user.id)).to eq user
        end
      end
    end

    context 'when logged out' do
      it 'return 404: Not Found' do
        delete user_registration_path, params: { format: :json }, headers: v1_headers

        expect(response.status).to eq 404
      end
    end
  end
end
