require "redis"

class GovukRedisClient
  include Singleton

  attr_reader :connection

  def initialize
    @connection = Redis.new
  end
end
