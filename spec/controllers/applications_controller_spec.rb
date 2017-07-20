require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:token) { SecureRandom.hex(32) }
  let(:user) { UsersApi::User.new(id: 1, token: token, username: 'testuser') }

  controller do
    before_action :authenticate!

    def index
      render json: current_user, status: :ok
    end
  end

  subject { get :index }

  describe '#authenticate!' do
    context 'when token is invalid' do
      before do
        allow(UsersApi::UsersService).to receive(:authenticate).and_return('errors' => ['Unauthoried'])
      end

      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when token is valid' do
      before do
        controller.request.headers['X-Auth-Token'] = token
        allow(UsersApi::UsersService).to receive(:authenticate).with(token).and_return(user)
      end

      it 'should pass back the user' do
        expect(subject.body).to eq(user.to_json)
      end
    end
  end

  describe '#current_user' do
    before do
      controller.request.headers['X-Auth-Token'] = token
      allow(UsersApi::UsersService).to receive(:authenticate).with(token).and_return(user)
    end

    it 'authenticates with the token' do
      expect(UsersApi::UsersService).to receive(:authenticate).with(token)
      subject
    end
  end
end
