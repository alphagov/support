require 'shared/request'
require 'shared/with_time_constraint'
require 'shared/with_request_context'

class NewFeatureRequest < Request
  include WithTimeConstraint
  include WithRequestContext

  attr_accessor :user_need, :url_of_example
  validates_presence_of :user_need

  def self.label
    "New feature/need"
  end

  def self.accessible_by_roles
    [ ContentRequesters, SinglePointsOfContact ]
  end
end