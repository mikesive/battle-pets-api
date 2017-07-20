class UsersController < ApplicationController
  before_action :authenticate!, only: [:update]
  def create
    response = UsersApi::UsersService.create(user_params.to_h.symbolize_keys)
    if errors = response['errors']
      render json: errors, status: :internal_server_error
    else
      render json: { token: response['token'] }, status: :ok
    end
  end

  def update
    result = UsersApi::UsersService.update(
      user_params.to_h.symbolize_keys.merge(token: current_user.token)
    )
    if errors = result['errors']
      render json: errors, status: :internal_server_error
    else
      render json: { success: 'User updated.' }, status: :ok
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :username)
  end
end
