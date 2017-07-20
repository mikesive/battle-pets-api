module UsersApi
  class User
    attr_reader :id
    attr_reader :token
    attr_reader :username

    def initialize(id:, token:, username:)
      @id = id
      @token = token
      @username = username
    end
  end
end
