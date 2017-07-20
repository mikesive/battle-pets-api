class SessionsClient < CarrotRpc::RpcClient
  queue_name "sessions_queue"

  def create(params)
    remote_call('create', params)
  end
end
