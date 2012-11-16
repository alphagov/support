require 'tableless_model'
require 'requester'

class GeneralRequest < TablelessModel
  attr_accessor :requester, :url, :additional, :user_agent

  validates_presence_of :requester
  validate do |request|
    if request.requester and not request.requester.valid?
      errors[:base] << "Requester details are either not complete or invalid."
    end
  end

  def requester_attributes=(attr)
    self.requester = Requester.new(attr)
  end
end