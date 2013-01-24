require 'tableless_model'
require 'with_requester'
require 'with_time_constraint'
require 'with_request_context'

class NewFeatureRequest < TablelessModel
  include WithRequester
  include WithTimeConstraint
  include WithRequestContext

  attr_accessor :user_need, :url_of_example
  validates_presence_of :user_need

  def self.label
    "New feature/need"
  end
end