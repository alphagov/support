require 'gds-sso/user'

class User < OpenStruct
  def self.attr_accessible(*args)
  end

  include GDS::SSO::User

  def self.find_by_uid(uid)
    auth_hash = Rails.cache.fetch(uid)
    auth_hash ? User.new(auth_hash) : nil
  end

  def self.create!(auth_hash, options={})
    Rails.cache.write(auth_hash["uid"], auth_hash)
    User.new(auth_hash)
  end

  def remotely_signed_out?
    remotely_signed_out
  end

  def update_attribute(key, value)
    if uid
      old_attributes = Rails.cache.fetch(uid)
      new_attributes = old_attributes.merge(key => value)
      Rails.cache.write(new_attributes["uid"], new_attributes)
    end
    send("#{key}=", value)
  end

  def update_attributes(params, hash)
    params.each do |key, value|
      send("#{key}=", value)
    end
    Rails.cache.write(params["uid"], params)
  end
end
