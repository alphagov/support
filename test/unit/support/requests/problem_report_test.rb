# encoding: UTF-8
require 'test_helper'
require 'support/requests/problem_report'

module Support
  module Requests
    class ProblemReportTest < Test::Unit::TestCase
      should validate_presence_of(:requester)

      should allow_value("abc").for(:what_doing)
      should allow_value("abc").for(:what_wrong)

      should allow_value("https://www.gov.uk/x").for(:url)
      should allow_value(nil).for(:url)
      should_not allow_value("http://bla.example.org:9292/méh/fào?bar").for(:url)

      should allow_value("https://www.gov.uk/y").for(:referrer)
      should allow_value(nil).for(:referrer)
      should_not allow_value("http://bla.example.org:9292/méh/fào?bar").for(:referrer)

      should allow_value("Safari").for(:user_agent)
      should allow_value("inside_government").for(:source)
      should allow_value(true).for(:javascript_enabled)
      should allow_value("hmrc").for(:page_owner)

      should "have the anonymous email address as the requester email by default" do
        assert_equal ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL, ProblemReport.new.requester.email
      end

      should "have a valid default requester" do
        assert ProblemReport.new.requester.valid?
      end

      should "know if the referrer is from GOV.UK or not" do
        assert ProblemReport.new(referrer: "https://www.gov.uk").referrer_url_on_gov_uk?
        refute ProblemReport.new(referrer: "https://some.service.gov.uk").referrer_url_on_gov_uk?
        refute ProblemReport.new(referrer: "http://www.google.com").referrer_url_on_gov_uk?
        refute ProblemReport.new(referrer: nil).referrer_url_on_gov_uk?
      end
    end
  end
end
