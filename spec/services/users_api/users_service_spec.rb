require 'rails_helper'

RSpec.describe UsersApi::UsersService do
  let(:response) { { 'data' => 'data' } }
  let(:sessions_client) { double(SessionsClient, create: 'create') }
  let(:token) { SecureRandom.hex }
  let(:user_data) { { 'id' => 1, 'username' => 'michael' } }
  let(:users_client) { double(UsersClient, create: 'create', show: 'show', update: 'update') }

  before do
    allow(SessionsClient).to receive(:new).and_return(sessions_client)
    allow(UsersClient).to receive(:new).and_return(users_client)
    allow(users_client).to receive(:show).and_return(user_data)
  end

  describe '.authenticate' do
    subject { described_class.authenticate(token) }

    context 'invalid credentials' do
      before { allow(users_client).to receive(:show).and_return('errors' => ['Unauthorized']) }
      it { is_expected.not_to be_a(UsersApi::User) }
    end

    it 'should request the user resource' do
      expect(users_client).to receive(:show).with(token: token)
      subject
    end

    it { is_expected.to be_a(UsersApi::User) }
  end
end
