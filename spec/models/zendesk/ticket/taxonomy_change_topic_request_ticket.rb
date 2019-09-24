require "rails_helper"

module Zendesk
  module Ticket
    describe TaxonomyChangeTopicRequestTicket do
      def ticket(opts)
        defaults = { requester: nil, title: nil }
        TaxonomyChangeTopicRequestTicket.new(double(defaults.merge(opts)))
      end

      subject { ticket }
      its(:tags) { should include("taxonomy_change_topic") }
      its(:subject) { should eq("") }

      context "with a title" do
        subject { ticket(title: "ABC") }
        its(:subject) { should eq("ABC") }
      end
    end
  end
end
