class ContentRequesters
  def self.role_applies_to_user?(user)
    user.has_permission?('content_requesters')
  end
end