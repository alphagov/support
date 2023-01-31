require "govuk_redis_client"

class Support::Requests::Anonymous::Paths
  EXPIRATION_TTL = 7.days

  def initialize(paths, id = nil)
    @id = id || SecureRandom.hex(10)
    @paths = paths
  end

  attr_reader :id, :paths

  def save
    key = self.class.redis_key(id:)
    self.class.redis.setex(key, EXPIRATION_TTL, paths.to_json)
  end

  def self.find(id)
    key = redis_key(id:)
    paths = JSON.parse(redis.get(key))
    new(paths, id)
  rescue TypeError
    nil
  end

  def self.redis_key(id:)
    "anonymous-paths:#{id}"
  end

  def self.redis
    GovukRedisClient.instance.connection
  end
end
