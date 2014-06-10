require 'test_helper'
require 'support/requests/unpublish_content_request'

module Support
  module Requests
    class UnpublishContentRequestTest < Test::Unit::TestCase
      def request(opts = {})
        UnpublishContentRequest.new(opts).tap { |r| r.valid? }
      end

      should validate_presence_of(:requester)
      should validate_presence_of(:reason_for_unpublishing)
      should validate_presence_of(:urls)

      should allow_value("abc").for(:further_explanation)
      should allow_value("abc").for(:redirect_url)

      should allow_value("1").for(:automatic_redirect)
      should allow_value("0").for(:automatic_redirect)
      should allow_value(nil).for(:automatic_redirect)
      should_not allow_value("xxx").for(:automatic_redirect)

      should "provide options for the unpublishing reason" do
        assert_equal 3, request.reason_for_unpublishing_options.size
      end

      should "provide formatted reason for unpublishing content" do
        assert_equal "Published in error", request(reason_for_unpublishing: "published_in_error").formatted_reason_for_unpublishing
      end

      should "validate presence of the redirect url if the reason for publishing involves another page" do
        assert_not_nil request(reason_for_unpublishing: "duplicate_publication").errors.get(:redirect_url)
        assert_not_nil request(reason_for_unpublishing: "superseded_publication").errors.get(:redirect_url)

        assert_nil request(reason_for_unpublishing: "published_in_error").errors.get(:redirect_url)
      end

      should "specify whether the redirect is automatic or not if the reason involves another page" do
        assert_not_nil request(reason_for_unpublishing: "duplicate_publication", automatic_redirect: nil).errors.get(:automatic_redirect)
        assert_not_nil request(reason_for_unpublishing: "superseded_publication", automatic_redirect: nil).errors.get(:automatic_redirect)

        assert_nil request(reason_for_unpublishing: "published_in_error", automatic_redirect: nil).errors.get(:automatic_redirect)
      end

      should "have automatic redirection selected by default" do
        assert request.automatic_redirect
      end
    end
  end
end
