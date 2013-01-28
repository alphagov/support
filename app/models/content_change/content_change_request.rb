require 'shared/tableless_model'
require 'shared/with_requester'
require 'shared/with_time_constraint'
require 'shared/with_request_context'

class ContentChangeRequest < TablelessModel
  include WithRequester
  include WithTimeConstraint
  include WithRequestContext

  attr_accessor :title, :details_of_change, :url, :related_urls
  validates_presence_of :details_of_change

  def self.label
    "Content change"
  end
end