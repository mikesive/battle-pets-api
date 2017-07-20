class SessionsController < ApplicationController
  def create
    response = UsersApi::UsersService.signin(
      session_params.to_h.symbolize_keys
    )
    if errors = response['errors']
      render json: errors, status: :unauthorized
    else
      render json: { token: response['token'] }, status: :ok
    end
  end

  private

  def session_params
    params.require(:session).permit(:password, :username)
  end
end
