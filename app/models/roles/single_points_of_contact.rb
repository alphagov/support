class SinglePointsOfContact
  def self.role_applies_to_user?(user)
    user.has_permission?('single_points_of_contact')
  end
end