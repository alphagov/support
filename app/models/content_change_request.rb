require 'tableless_model'
require 'with_requester'
require 'with_time_constraint'
require 'with_request_context'

class ContentChangeRequest < TablelessModel
  include WithRequester
  include WithTimeConstraint
  include WithRequestContext

  attr_accessor :details_of_change, :url, :related_urls
  validates_presence_of :details_of_change
end