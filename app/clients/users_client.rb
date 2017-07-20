class UsersClient < CarrotRpc::RpcClient
  queue_name "users_queue"

  def create(params)
    remote_call('create', params)
  end

  def show(params)
    remote_call('show', params)
  end

  def update(params)
    remote_call('update', params)
  end
end
