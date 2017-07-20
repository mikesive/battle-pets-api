require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:credentials) { { username: 'username', password: 'password' } }
  let(:session_params) { { session: credentials } }
  let(:token) { SecureRandom.hex(32) }
  let(:errors) { ['Some error.'] }

  describe '#create' do
    subject { post :create, params: session_params }

    before do
      allow(UsersApi::UsersService).to receive(:signin).with(credentials).and_return('token' => token)
    end

    context 'with invalid credentials' do
      before do
        allow(UsersApi::UsersService).to receive(:signin).with(credentials).and_return('errors' => errors)
      end
      it { is_expected.to have_http_status(:unauthorized) }
    end

    it 'should return the token' do
      expect(subject.body).to eq({ token: token }.to_json)
    end

    it { is_expected.to have_http_status(:ok) }
  end
end
