require "govuk_redis_client"

RSpec.configure do |config|
  config.before do
    GovukRedisClient.instance.connection.flushall
  end
end
