require 'test_helper'
require 'support/requests/foi_request'

module Support
  module Requests
    class FoiRequestTest < Test::Unit::TestCase
      should validate_presence_of(:requester)
      should allow_value("xyz").for(:details)
    end
  end
end
