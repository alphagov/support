module Zendesk
  module Ticket
    describe GeneralRequestTicket do
      def ticket(opts = {})
        GeneralRequestTicket.new(Support::Requests::GeneralRequest.new(opts.merge(:requester_attributes => {})))
      end

      it "has the urls in the comments if the url is present" do
        expect(ticket(url: "http://url").comment).to include("http://url")
      end

      it "has the a subject if no title set" do
        expect(ticket.subject).to eq("Govt Agency General Issue")
      end

      it "has the a subject if a title is set" do
        expect(ticket(title: "abc").subject).to eq("abc - Govt Agency General Issue")
      end

      it "has the appropriate tag set" do
        expect(ticket.tags).to include("govt_agency_general")
      end
    end
  end
end
