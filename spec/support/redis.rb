require "redis_client"

RSpec.configure do |config|
  config.before do
    RedisClient.instance.connection.flushall
  end
end
