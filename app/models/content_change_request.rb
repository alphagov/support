require 'tableless_model'
require 'with_requester'
require 'with_time_constraint'
require 'with_inside_government'

class ContentChangeRequest < TablelessModel
  include WithRequester
  include WithTimeConstraint
  include WithInsideGovernment

  attr_accessor :details_of_change, :url1, :url2, :url3
  validates_presence_of :details_of_change
end