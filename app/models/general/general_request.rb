require 'shared/request'

class GeneralRequest < Request
  attr_accessor :url, :additional, :user_agent

  def self.label
    "General"
  end

  def self.accessible_by_roles
    [ Anyone ]
  end
end
