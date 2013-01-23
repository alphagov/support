require 'tableless_model'
require 'with_requester'

class GeneralRequest < TablelessModel
  include WithRequester

  attr_accessor :url, :additional, :user_agent

  def self.label
    "General"
  end
end