CarrotRpc.configure do |config|
  config.bunny = Bunny.new
  config.loglevel = Logger::INFO
  config.logger = CarrotRpc::TaggedLog.new(logger: Rails.logger, tags: ["Carrot RPC Client"])
  config.before_request = proc { |params| }
  config.rpc_client_timeout = 20
end
CarrotRpc.connect
