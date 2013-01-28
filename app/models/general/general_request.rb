require 'shared/tableless_model'
require 'shared/with_requester'

class GeneralRequest < TablelessModel
  include WithRequester

  attr_accessor :url, :additional, :user_agent

  def self.label
    "General"
  end
end