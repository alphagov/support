require 'test_helper'
require 'support/requests/named_contact'

module Support
  module Requests
    class NamedContactTest < Test::Unit::TestCase
      should validate_presence_of(:requester)
      should validate_presence_of(:details)
      should allow_value("abc").for(:referrer)
      should allow_value("abc").for(:user_agent)

      should allow_value(true).for(:javascript_enabled)
      should allow_value(false).for(:javascript_enabled)
      should_not allow_value("abc").for(:javascript_enabled)

      should "provide the path if a GOV.UK link is specified" do
        assert_equal "/abc", NamedContact.new(link: "https://www.gov.uk/abc").govuk_link_path
        assert_nil NamedContact.new(link: "https://www.google.co.uk/ab").govuk_link_path
        assert_nil NamedContact.new(link: nil).govuk_link_path
      end
    end
  end
end
