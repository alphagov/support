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

  def update_attribute(*args)
  end

  def update_attributes(params, hash)
    User.new(params)
  end
end
