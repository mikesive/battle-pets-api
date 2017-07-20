class ApplicationController < ActionController::API
  protected

  # Ensures request is authenticated
  def authenticate!
    current_user || render_unauthorized
  end

  # Authenticates with the user service
  def current_user
    unless @current_user
      token = request.headers['X-Auth-Token']
      response = UsersApi::UsersService.authenticate(token)
      @current_user = response.is_a?(UsersApi::User) ? response : nil
    end
    @current_user
  end

  private

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
