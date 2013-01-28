require 'shared/tableless_model'
require 'shared/with_requester'
require 'shared/with_tool_role_choice'
require 'shared/with_time_constraint'

class RemoveUserRequest < TablelessModel
  include WithRequester
  include WithToolRoleChoice
  include WithTimeConstraint

  attr_accessor :user_name, :user_email, :reason_for_removal
  validates_presence_of :user_name, :user_email
  validates :user_email, :format => {:with => /@/}

  def self.label
    "Remove user"
  end
end