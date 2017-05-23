require 'rails_helper'

RSpec.describe 'Registrations API', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:password) { user.password }
  let(:wrong_password) { '1234512345' }

  describe '#destroy' do
    context 'when logged in' do
      context 'with valid params' do
        it 'destroys user record' do
          v1_auth_delete user, user_registration_path, params: { password: password}

          expect(response.status).to eq 200
          expect(User.exists?(user.id)).to be_falsey
        end
      end

      context 'with invalid params' do
        it 'leaves user as it is if wrong password passed' do
          v1_auth_delete user, user_registration_path, params: { password: wrong_password }

          expect(response.status).to eq 403
          expect(User.exists?(user.id)).to be_truthy
        end

        it 'leaves user as it is if no password passed' do
          v1_auth_delete user, user_registration_path

          expect(User.exists?(user.id)).to be_truthy
        end
      end
    end

    context 'when logged out' do
      it 'return 404: Not Found' do
        v1_delete user_registration_path

        expect(response.status).to eq 404
      end
    end
  end
end
