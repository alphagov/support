# encoding: UTF-8
require 'uri'
require 'test_helper'
require 'support/requests/anonymous/problem_report'

module Support
  module Requests
    module Anonymous
      class ProblemReportTest < Test::Unit::TestCase
        should allow_value("abc").for(:what_doing)
        should allow_value("abc").for(:what_wrong)

        should allow_value("Safari").for(:user_agent)
        should allow_value("inside_government").for(:source)
        should allow_value(true).for(:javascript_enabled)
        should allow_value("hmrc").for(:page_owner)

        should allow_value("a" * 2**16).for(:what_doing)
        should allow_value("a" * 2**16).for(:what_wrong)
        should_not allow_value("a" * (2**16+1)).for(:what_doing)
        should_not allow_value("a" * (2**16+1)).for(:what_wrong)

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
end
