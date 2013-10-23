require 'test_helper'
require 'support/requests/anonymous/long_form_contact'

module Support
  module Requests
    module Anonymous
      class LongFormContactTest < Test::Unit::TestCase
        should validate_presence_of(:details)
        should allow_value("abc").for(:referrer)
        should allow_value("abc").for(:user_agent)

        should allow_value("https://www.gov.uk").for(:link)
        should allow_value("http://" + ("a" * 2040)).for(:link)
        should_not allow_value("http://" + ("a" * 2050)).for(:link)

        should allow_value(true).for(:javascript_enabled)
        should allow_value(false).for(:javascript_enabled)

        should allow_value("a" * 2**16).for(:details)
        should_not allow_value("a" * (2**16+1)).for(:details)

        should "not allow random values for javascript_enabled" do
          refute LongFormContact.new(javascript_enabled: "abc").javascript_enabled
        end

        should "have the anonymous email address as the requester email by default" do
          assert_equal ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL, LongFormContact.new.requester.email
        end

        should "have a valid default requester" do
          assert LongFormContact.new.requester.valid?
        end

        should "provide the path if a GOV.UK link is specified" do
          assert_equal "/abc", LongFormContact.new(link: "https://www.gov.uk/abc").govuk_link_path
          assert_nil LongFormContact.new(link: "https://www.google.co.uk/ab").govuk_link_path
          assert_nil LongFormContact.new(link: nil).govuk_link_path
        end
      end
    end
  end
end
