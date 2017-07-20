require 'rails_helper'

RSpec.describe BattlePetsController, type: :controller do
  let(:battle_pet_params) { { battle_pet: { name: 'pet', agility: 1, intelligence: 1, senses: 1, strength: 1 } } }
  let(:user) { UsersApi::User.new(id: 1, username: 'testuser', token: SecureRandom.hex(32)) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(Sidekiq::Client).to receive(:push).and_return(SecureRandom.hex(32))
  end

  describe '#create' do
    subject { post :create, params: battle_pet_params }

    context 'when attribute is too high' do
      before { battle_pet_params[:battle_pet][:agility] = 20 }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end

    it { expect { subject }.to change { BattlePet.count }.by(1) }

    it 'should queue a recruitment job' do
      expect(Sidekiq::Client).to receive(:push).with(hash_including('class' => 'RecruitmentWorker'))
      subject
    end

    it { is_expected.to have_http_status(:created) }
  end
end
