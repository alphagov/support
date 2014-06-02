require 'test_helper'
require 'support/requests/general_request'

module Support
  module Requests
    class GeneralRequestTest < Test::Unit::TestCase
      should validate_presence_of(:requester)
      should validate_presence_of(:details)

      should allow_value("xxx").for(:title)

      should allow_value("https://www.gov.uk").for(:url)

      should allow_value("a comment").for(:details)
    end
  end
end
