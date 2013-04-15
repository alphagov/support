require 'shared/with_requester'

class Request < TablelessModel
  include WithRequester

  def self.accessible_by_user?(user)
    accessible_by_roles.any? { |role| role.role_applies_to_user?(user) }
  end

  def self.accessible_by_roles
    raise "should be overridden by subclasses"
  end
end
