require 'shared/request'

class GeneralRequest < Request
  attr_accessor :url, :additional, :user_agent

  def self.label
    "General"
  end
end