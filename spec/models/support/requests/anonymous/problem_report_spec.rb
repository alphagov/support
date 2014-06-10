# encoding: UTF-8
require 'uri'
require 'rails_helper'
require 'support/requests/anonymous/problem_report'

module Support
  module Requests
    module Anonymous
      describe ProblemReport do
        it { should allow_value("abc").for(:what_doing) }
        it { should allow_value("abc").for(:what_wrong) }

        it { should allow_value("Safari").for(:user_agent) }
        it { should allow_value("inside_government").for(:source) }
        it { should allow_value(true).for(:javascript_enabled) }
        it { should allow_value("hmrc").for(:page_owner) }

        it { should allow_value("a" * 2**16).for(:what_doing) }
        it { should allow_value("a" * 2**16).for(:what_wrong) }
        it { should_not allow_value("a" * (2**16+1)).for(:what_doing) }
        it { should_not allow_value("a" * (2**16+1)).for(:what_wrong) }

        it "has the anonymous email address as the requester email by default" do
          expect(ProblemReport.new.requester.email).to eq(ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL)
        end

        it "has a valid default requester" do
          expect(ProblemReport.new.requester).to be_valid
        end

        def on_gov_uk?(referrer)
          ProblemReport.new(referrer: referrer).referrer_url_on_gov_uk?
        end

        it "knows if the referrer is from GOV.UK or not" do
          expect(on_gov_uk?("https://www.gov.uk")).to be_truthy
          expect(on_gov_uk?("https://some.service.gov.uk")).to be_falsey
          expect(on_gov_uk?("http://www.google.com")).to be_falsey
          expect(on_gov_uk?(nil)).to be_falsey
        end
      end
    end
  end
end
