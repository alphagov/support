require 'shared/request'
require 'shared/with_tool_role_choice'
require 'shared/with_time_constraint'

class RemoveUserRequest < Request
  include WithToolRoleChoice
  include WithTimeConstraint

  attr_accessor :user_name, :user_email, :reason_for_removal
  validates_presence_of :user_name, :user_email
  validates :user_email, :format => {:with => /@/}

  def self.label
    "Remove user"
  end

  def self.accessible_by_roles
    [ Anyone ]
  end
end