require 'gds-sso/user'

class ReadOnlyUser < OpenStruct
  def self.attr_accessible(*args)
  end

  include GDS::SSO::User

  def self.find_by_uid(uid)
    ReadOnlyUser.new(uid: uid)
  end

  def self.create!(auth_hash, options={})
    ReadOnlyUser.new(auth_hash)
  end

  def update_attribute(*args)
  end

  def update_attributes(params, hash)
    ReadOnlyUser.new(params)
  end
end
