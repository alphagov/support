require "redis_client"

module Support::Requests::Anonymous
  class Paths
    EXPIRATION_TTL = 7.days

    def initialize(paths, id = nil)
      @id = id || SecureRandom.hex(10)
      @paths = paths
    end

    attr_reader :id, :paths

    def save
      key = Paths.redis_key(id: id)
      Paths.redis.setex(key, EXPIRATION_TTL, paths.to_json)
    end

    def self.find(id)
      key = redis_key(id: id)
      paths = JSON.parse(redis.get(key))
      Paths.new(paths, id)
    rescue TypeError
      nil
    end

    def self.redis_key(id:)
      "anonymous-paths:#{id}"
    end

    def self.redis
      RedisClient.instance.connection
    end
  end
end
