require 'rails_helper'

RSpec.describe 'Registrations API', version: :v1, type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:password) { user.password }
  let(:wrong_password) { '1234512345' }

  describe '#destroy' do
    context 'when logged in' do
      context 'with valid params' do
        it 'destroys user record' do
          auth_delete user, user_registration_path, params: { password: password}, headers: v1_headers

          expect(response.status).to eq 200
          expect(User.exists?(user.id)).to be_falsey
        end
      end

      context 'with invalid params' do
        it 'leaves user as it is if wrong password passed' do
          auth_delete user, user_registration_path, params: { password: wrong_password }, headers: v1_headers

          expect(response.status).to eq 403
          expect(User.exists?(user.id)).to be_truthy
        end

        it 'leaves user as it is if no password passed' do
          auth_delete user, user_registration_path, headers: v1_headers

          expect(User.exists?(user.id)).to be_truthy
        end
      end
    end

    context 'when logged out' do
      it 'return 404: Not Found' do
        delete user_registration_path, headers: v1_headers

        expect(response.status).to eq 404
      end
    end
  end
end
