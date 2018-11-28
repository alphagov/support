require 'redis'

class RedisClient
  include Singleton

  attr_reader :connection

  def initialize
    @connection = Redis.new
  end
end
