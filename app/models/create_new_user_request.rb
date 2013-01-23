require 'tableless_model'
require 'with_requester'
require 'with_tool_role_choice'

class CreateNewUserRequest < TablelessModel
  include WithRequester
  include WithToolRoleChoice

  attr_accessor :requested_user, :additional_comments
  validates_presence_of :requested_user
  def requested_user_attributes=(attr)
    self.requested_user = RequestedUser.new(attr)
  end

  def self.label
    "Create new user"
  end
end