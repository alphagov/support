require 'test/unit'
require 'shoulda/context'
require 'support/requests/problem_report'
require 'zendesk/ticket/problem_report_ticket'
require 'ostruct'

module Zendesk
  module Ticket
    class ProblemReportTicketTest < Test::Unit::TestCase
      def ticket(opts)
        ProblemReportTicket.new(Support::Requests::ProblemReport.new(opts))
      end

      should "contain the URL path in the subject, if one is provided" do
        assert_equal "/abc/def", ticket(url: "http://www.gov.uk/abc/def").subject
      end

      should "contain a subject even if no URL is available" do
        assert_equal "Unknown page", ticket(url: nil).subject
      end

      should "render the url in the description even if it's unknown" do
        assert_includes ticket(url: nil).comment, "url: unknown"
      end

      should "render the url in the description even if it known" do
        assert_includes ticket(url: "https://www.gov.uk/abc").comment, "url: https://www.gov.uk/abc"
      end

      should "be tagged with the page owner, if one is provided" do
        assert_includes ticket(page_owner: "hmrc").tags, "page_owner/hmrc"
        refute ticket(page_owner: nil).tags.any? {|tag| tag =~ /page_owner/}
      end

      should "be tagged appropriately if the user was referred by a GOV.UK URL" do
        assert_includes ticket(referrer: "https://www.gov.uk/abc/def").tags, "govuk_referrer"
        refute_includes ticket(referrer: "https://www.council.gov.uk/abc/def").tags, "govuk_referrer"
      end
    end
  end
end
