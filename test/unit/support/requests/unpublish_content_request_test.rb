require 'test_helper'
require 'support/requests/unpublish_content_request'

module Support
  module Requests
    class UnpublishContentRequestTest < Test::Unit::TestCase
      should validate_presence_of(:requester)
      should validate_presence_of(:reason_for_unpublishing)
      should validate_presence_of(:urls)

      should allow_value("abc").for(:further_explanation)

      should "provide options for the unpublishing reason" do
        assert_equal 3, UnpublishContentRequest.new.reason_for_unpublishing_options.size
      end

      should "provide formatted reason for unpublishing content" do
        assert_equal "Published in error", UnpublishContentRequest.new(reason_for_unpublishing: "published_in_error").formatted_reason_for_unpublishing
      end
    end
  end
end