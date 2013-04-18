require 'shared/request'
require 'shared/with_time_constraint'
require 'shared/with_request_context'

class ContentChangeRequest < Request
  include WithTimeConstraint
  include WithRequestContext

  attr_accessor :title, :details_of_change, :url, :related_urls
  validates_presence_of :details_of_change

  def self.label
    "Content change"
  end

  def self.accessible_by_roles
    [ ContentRequesters, SinglePointsOfContact ]
  end
end