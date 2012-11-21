require 'tableless_model'
require 'with_requester'
require 'with_time_constraint'

class NewFeatureRequest < TablelessModel
  include WithRequester
  include WithTimeConstraint

  attr_accessor :user_need, :url_of_example
end