require 'rails_helper'

RSpec.describe BattlesController, type: :controller do
  let(:battle_params) { { battle: { battle_type: :strength, contestant_ids: user_pets.map(&:id) } } }
  let(:petone) { FactoryGirl.build_stubbed(:battle_pet, id: 1, name: 'petone', user_id: user.id) }
  let(:pettwo) { FactoryGirl.build_stubbed(:battle_pet, id: 2, name: 'pettwo', user_id: user.id) }
  let(:petthree) { FactoryGirl.build_stubbed(:battle_pet, id: 3, name: 'petthree', user_id: user.id) }
  let(:pets) { [petone, pettwo] }
  let(:user_pets) do
    double(count: pets.count, update_all: true, first: pets.first, last: pets.last, map: pets.map(&:id))
  end
  let(:user) { UsersApi::User.new(id: 1, username: 'testuser', token: SecureRandom.hex(32)) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(Sidekiq::Client).to receive(:push).and_return(SecureRandom.hex(32))
  end

  describe '#create' do
    subject { post :create, params: battle_params }
    before do
      allow(BattlePet).to receive(:where).and_return(user_pets)
    end
    context 'when there are too many ids given' do
      before { allow(user_pets).to receive(:count).and_return(3) }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end

    context 'invalid battle type' do
      before { battle_params[:battle][:battle_type] = 'wits' }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end

    it 'should create a battle' do
      expect { subject }.to change { Battle.count }.by(1)
    end

    it 'should change the pets status' do
      expect(user_pets).to receive(:update_all).with(status: 'fighting')
      subject
    end

    it 'should push a new job to the queue' do
      expect(Sidekiq::Client).to receive(:push).with(hash_including('class' => 'ContestWorker'))
      subject
    end
  end
end
