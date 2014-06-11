require 'rails_helper'
require 'support/requests/anonymous/problem_report'
require 'zendesk/ticket/problem_report_ticket'

module Zendesk
  module Ticket
    describe ProblemReportTicket do
      def ticket(opts)
        ProblemReportTicket.new(Support::Requests::Anonymous::ProblemReport.new(opts))
      end

      context "for a GOV.UK URL" do
        subject { ticket(url: "https://www.gov.uk/abc/def") }
        its(:subject) { should eq("/abc/def") }
        its(:comment) { should include("url: https://www.gov.uk/abc/def") }
      end

      context "for a page with an owning department" do
        subject { ticket(page_owner: "hmrc") }
        its(:tags) { should include("page_owner/hmrc") }
      end

      it "isn't tagged with the page owner if none is provided" do
        expect(ticket(page_owner: nil).tags.any? {|tag| tag =~ /page_owner/}).to be_falsey
      end

      context "where the URL is unknown" do
        subject { ticket(url: nil) }
        its(:subject) { should eq("Unknown page") }
        its(:comment) { should include("url: unknown") }
      end

      it "should be tagged with the source, if one is provided" do
        expect(ticket(source: "inside_government").tags).to include("inside_government")
        expect(ticket(source: nil).tags).to_not include("inside_government")
      end

      it "is tagged appropriately if the user was referred by a GOV.UK URL" do
        expect(ticket(referrer: "https://www.gov.uk/abc/def").tags).to include("govuk_referrer")
        expect(ticket(referrer: "https://www.council.gov.uk/abc/def").tags).to_not include("govuk_referrer")
      end
    end
  end
end
