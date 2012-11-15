require 'requester'

class GeneralRequest
  include ActiveAttr::Model

  attribute :requester, :type       => Requester,
                        :typecaster => lambda { |params| Requester.new(params) }
  attribute :url
  attribute :additional
  attribute :user_agent

  validates_presence_of :requester
  validate do |request|
    errors[:base] << "Requester details are either not complete or invalid." if not request.requester.nil? and not request.requester.valid?
  end
end