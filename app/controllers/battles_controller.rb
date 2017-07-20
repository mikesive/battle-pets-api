class BattlesController < SecureController

  # This implementation allows you to battle any pets, including your own.
  # I have not designed a more versatile system given time limitation.
  def new
    # Find all pets available for battle
    pets = BattlePet.where(status: 'active')
    user_pets = pets.where(user_id: current_user.id)
    other_pets = pets.where.not(user_id: current_user.id)
    render json: { user: user_pets, other: other_pets }, status: :ok
  end

  def index
    battles = Battle.where(user_id: current_user.id)
    render json: battles, status: :ok
  end

  # Once controllers become messy like this, I usually like to use the Command Object pattern
  # The interactor gem (https://github.com/collectiveidea/interactor) is a great implementation of this pattern
  # However for simplicity's sake I am leaving this logic in the controller (although it hurts!)
  def create
    Battle.transaction do
      pets = BattlePet.where(id: battle_params[:contestant_ids], status: 'active')
      battle_type = battle_params[:battle_type]

      # Ensure battle type is correct
      valid_attributes = BattlePet::ATTRIBUTES
      if !valid_attributes.include?(battle_type)
        render json: { error: "Invalid battle_type. Valid types are #{valid_attributes.join(', ')}" }, status: :unprocessable_entity

      # Ensure the user has given us 2 valid pet_ids for battle
      elsif pets.count != 2 || !pets.map(&:user_id).include?(current_user.id)
        render json: { error: 'Invalid contestant_ids. You must choose 2 active pets, one of which you must own.' }, status: :unprocessable_entity

      else
        # Set the pets state and create a battle
        pets.update_all(status: 'fighting')
        battle = Battle.create!(
          contestant_ids: pets.map(&:id),
          battle_type: battle_type,
          status: 'incomplete',
          user_id: current_user.id
        )

        # Queue up a job for completing the battle
        job_id = Sidekiq::Client.push(
          'class' => 'ContestWorker',
          'args' => [{
            first_contestant: pets.first.to_h,
            second_contestant: pets.last.to_h,
            battle_id: battle.id,
            battle_type: battle_type
          }],
          'queue' => 'workers'
        )

        # Add job_id to battle
        battle.update!(job_id: job_id)

        render json: battle, status: :ok
      end
    end
  end

  def show
    battle = Battle.where(user_id: current_user.id).find(params['id'])
    render json: battle, status: :ok
  end

  private

  def battle_params
    params.require(:battle).permit(:battle_type, contestant_ids: [])
  end
end
