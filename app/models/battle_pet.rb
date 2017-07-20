class BattlePet < ApplicationRecord
  ATTRIBUTES = ['agility', 'intelligence', 'senses', 'strength']
  attr_accessor :loss_count
  attr_accessor :win_count

  MAX_ATTR_LIMIT = {
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 10
    }
  }

  has_many :losses, foreign_key: :loser_id, class_name: 'Battle'
  has_many :wins, foreign_key: :winner_id, class_name: 'Battle'
  validates :name, presence: true
  validates :user_id, presence: true
  validates :agility, MAX_ATTR_LIMIT
  validates :intelligence, MAX_ATTR_LIMIT
  validates :senses, MAX_ATTR_LIMIT
  validates :strength, MAX_ATTR_LIMIT

  def to_h
    {
      id: id,
      agility: agility,
      experience: experience,
      intelligence: intelligence,
      name: name,
      senses: senses,
      strength: strength
    }
  end

  def as_json(_opts = {})
    if status == 'pending'
      { id: id, status: status }
    else
      to_h
    end
  end

  private

  def experience
    loss_count = losses.count
    win_count = wins.count
    total_count = loss_count + win_count
    # Give more experience based on win vs loss count
    (total_count + win_count) / (total_count.zero? ? 1 : total_count)

  end
end
