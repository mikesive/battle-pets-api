class BattlePetsController < SecureController

  # Once controllers become messy like this, I usually like to use the Command Object pattern
  # The interactor gem (https://github.com/collectiveidea/interactor) is a great implementation of this pattern
  # However for simplicity's sake I am leaving this logic in the controller (although it hurts!)
  def create
    BattlePet.transaction do
      attributes = battle_pet_params.to_h.symbolize_keys
      pet = BattlePet.new(
        attributes.merge(user_id: current_user.id)
      )

      if pet.save
        # If we have valid battlepet, push a recruitment task to the workers
        job_id = Sidekiq::Client.push(
          'class' => 'RecruitmentWorker',
          'args' => [pet.to_h],
          'queue' => 'workers'
        )
        pet.update!(job_id: job_id)
        render json: pet, status: :created
      else

        # Otherwise return an error to the user
        render json: pet.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  def index
    pets = BattlePets.where(user_id: current_user.id)
    render json: pets, status: :ok
  end

  def show
    pet = BattlePet.find(params[:id])
    render json: pet, status: :ok
  end

  private

  def battle_pet_params
    params.require(:battle_pet).permit(:agility, :intelligence, :name, :senses, :strength)
  end
end
