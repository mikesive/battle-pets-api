class BattleFinalizationWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'management'

  def perform(params)
    battle = Battle.find(params['battle_id'])
    winner = params['winner']
    winner_id = winner['id']
    loser = params['loser']
    loser_id = loser['id']
    unique_hash = params['unique_hash']

    battle.update!(
      loser_id: loser_id,
      winner_id: winner_id,
      status: 'complete',
      unique_hash: unique_hash
    )

    BattlePet.where(id: [winner_id, loser_id]).update_all(status: 'active')
  end
end
