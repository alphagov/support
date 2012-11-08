require 'support_request'

class ContentChangeRequest < SupportRequest
  attr_accessor :add_content

  validates_presence_of :add_content
end