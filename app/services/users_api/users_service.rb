module UsersApi
  class UsersService

    # Queries the user service to ensure that the token is valid
    # and returns the associated user
    def self.authenticate(token)
      rpc_client = UsersClient.new
      response = rpc_client.show(token: token)
      if errors = response['errors']
        errors
      else
        User.new(response.symbolize_keys.merge(token: token))
      end
    end

    # Creates a new user and returns an auth token for that user
    def self.create(user_params)
      rpc_client = UsersClient.new
      rpc_client.create(user_params)
    end

    # Updates the user at the User service
    def self.update(user_params)
      rpc_client = UsersClient.new
      rpc_client.update(user_params)
    end

    # Signs in user using username and password combo
    # to get an auth token for subsequest api calls
    def self.signin(credentials)
      rpc_client = SessionsClient.new
      rpc_client.create(credentials)
    end
  end
end
