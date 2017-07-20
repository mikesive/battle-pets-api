class Battle < ApplicationRecord
  belongs_to :loser, class_name: 'BattlePet', foreign_key: :loser_id, optional: true
  belongs_to :winner, class_name: 'BattlePet', foreign_key: :winner_id, optional: true

  def as_json(_opts = {})
    {
      id: id,
      battle_type: battle_type,
      contestants: contestants,
      status: status,
      winner: winner
    }
  end

  def contestants
    BattlePet.where(id: contestant_ids)
  end
end
