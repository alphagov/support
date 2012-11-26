require 'tableless_model'
require 'with_requester'
require 'with_inside_government'

class CreateNewUserRequest < TablelessModel
  include WithRequester
  include WithInsideGovernment

  attr_accessor :user_name, :user_email, :additional_comments
  validates_presence_of :user_name, :user_email
  validates :user_email, :format => {:with => /@/}
end