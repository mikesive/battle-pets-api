require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:errors) { ['some error'] }
  let(:token) { SecureRandom.hex(32) }
  let(:user) { UsersApi::User.new(id: 1, username: 'testuser', token: token) }
  let(:user_params) { { user: { username: 'testuser', password: 'password' } } }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe '#create' do
    subject { post :create, params: user_params }

    before do
      allow(UsersApi::UsersService).to receive(:create).and_return('token' => token)
    end

    context 'when there is an input error' do
      before do
        allow(UsersApi::UsersService).to receive(:create).with(
          user_params[:user]
        ).and_return('errors' => errors)
      end

      it { is_expected.to have_http_status(:internal_server_error) }
    end


    it 'should call create' do
      expect(UsersApi::UsersService).to receive(:create)
      subject
    end

    it 'should return the token' do
      expect(subject.body).to eq({ token: token }.to_json)
    end

    it { is_expected.to have_http_status(:ok) }
  end

  describe '#update' do
    subject { put :update, params: user_params }

    before do
      allow(UsersApi::UsersService).to receive(:update).and_return(success: 'Updated user.')
    end

    context 'when there is an input error' do
      before do
        allow(UsersApi::UsersService).to receive(:update).and_return('errors' => errors)
      end

      it { is_expected.to have_http_status(:internal_server_error) }
    end

    it 'should update the user' do
      expect(UsersApi::UsersService).to receive(:update)
      subject
    end

    it { is_expected.to have_http_status(:ok) }
  end
end
