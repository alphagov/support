require 'gds-sso/user'
require 'json'
require 'redis_client'

class User < OpenStruct
  class Store
    class << self
      def write(uid, attributes)
        redis.setex prefixed_key(uid), 1.day, attributes.to_json
      end

      def fetch(uid)
        data = redis.get(prefixed_key(uid))
        data && JSON.parse(data)
      end

    private

      def prefixed_key(key)
        "support-#{Rails.env}:users-#{key}"
      end

      def redis
        RedisClient.instance.connection
      end
    end
  end

  def self.attr_accessible(*_args); end

  include GDS::SSO::User
  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Support::Permissions::Ability.new(self)
  end

  def self.where(options)
    uid = options[:uid]
    auth_hash = Store.fetch(uid)
    return [] unless auth_hash && user_matches?(options, User.new(auth_hash))

    [User.new(auth_hash)]
  end

  def self.user_matches?(options, user)
    options.all? { |key, value| user.send(key.to_sym) == value }
  end

  def self.upsert!(auth_hash, _options = {})
    Store.write(auth_hash["uid"], auth_hash)
    User.new(auth_hash)
  end

  class << self
    alias :create! :upsert!
  end

  def disabled?
    disabled
  end

  def remotely_signed_out?
    remotely_signed_out
  end

  def update_attribute(key, value)
    if uid
      old_attributes = Store.fetch(uid) || {}
      new_attributes = old_attributes.merge(key => value)
      Store.write(new_attributes["uid"], new_attributes)
    end
    send("#{key}=", value)
  end

  def update_attributes(params, _hash = nil)
    params.each do |key, value|
      send("#{key}=", value)
    end
    Store.write(params["uid"], params)
  end
end
