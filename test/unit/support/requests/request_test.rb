require 'test_helper'
require 'support/requests/requester'

module Support
  module Requests
    class RequestTest < Test::Unit::TestCase
      should "be initialized with a requester" do
        assert_not_nil Request.new.requester
      end
    end
  end
end