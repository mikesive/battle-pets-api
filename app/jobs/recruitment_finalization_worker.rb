class RecruitmentFinalizationWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'management'

  def perform(params)
    pet = BattlePet.find(params['id'])
    pet.update!(
      agility: params['agility'],
      intelligence: params['intelligence'],
      senses: params['senses'],
      status: 'active',
      strength: params['strength']
    )
  end
end
