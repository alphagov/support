require 'gds-sso/user'

class User < OpenStruct
  def self.attr_accessible(*args)
  end

  include GDS::SSO::User
  delegate :can?, :cannot?, :to => :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def self.find_by_uid(uid)
    auth_hash = Rails.cache.fetch(prefixed_key(uid))
    auth_hash ? User.new(auth_hash) : nil
  end

  def self.create!(auth_hash, options={})
    Rails.cache.write(prefixed_key(auth_hash["uid"]), auth_hash)
    User.new(auth_hash)
  end

  def remotely_signed_out?
    remotely_signed_out
  end

  def update_attribute(key, value)
    if uid
      old_attributes = Rails.cache.fetch(self.class.prefixed_key(uid))
      new_attributes = old_attributes.merge(key => value)
      Rails.cache.write(self.class.prefixed_key(new_attributes["uid"]), new_attributes)
    end
    send("#{key}=", value)
  end

  def update_attributes(params, hash)
    params.each do |key, value|
      send("#{key}=", value)
    end
    Rails.cache.write(self.class.prefixed_key(params["uid"]), params)
  end

  def self.prefixed_key(key)
    "users-#{key}"
  end
end
