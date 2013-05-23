require 'test/unit'
require 'shoulda/context'
require 'zendesk/ticket/general_request_ticket'
require 'ostruct'

module Zendesk
  module Ticket
    class GeneralRequestTicketTest < Test::Unit::TestCase
      def ticket_with(opts)
        GeneralRequestTicket.new(GeneralRequest.new(opts.merge(:requester_attributes => {})))
      end

      def ticket
        ticket_with({})
      end

      context "a general request ticket" do
        should "have the urls in the comments if the url is present" do
          assert_includes ticket_with(:url => "http://url").comment, "http://url"
        end

        should "have the a subject" do
          assert_equal ticket.subject, "Govt Agency General Issue"
        end

        should "have the appropriate tag set" do
          assert_includes ticket.tags, "govt_agency_general"
        end
      end
    end
  end
end