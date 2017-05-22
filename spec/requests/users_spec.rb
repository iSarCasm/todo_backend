require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let(:user) { FactoryGirl.create(:user) }

  describe '#show' do
    context 'when logged in' do
      it 'returns the list of projects' do
        auth_get user, user_path(user.name), params: { format: :json }

        expect(response.status).to eq 200

        expect(json['uid']).to eq user.uid
        expect(json['name']).to eq user.name
        expect(json['email']).to eq user.email
      end
    end

    context 'when logged out' do
      it 'return 401: Unauthorized' do
        get user_path(user.name), params: { format: :json }

        expect(response.status).to eq 401
      end
    end
  end
end
