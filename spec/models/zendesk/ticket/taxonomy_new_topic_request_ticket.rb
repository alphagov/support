require 'spec_helper'
require 'zendesk/ticket/taxonomy_new_topic_request_ticket'

module Zendesk
  module Ticket
    describe TaxonomyNewTopicRequestTicket do
      def ticket(opts)
        defaults = { requester: nil, title: nil }
        TaxonomyNewTopicRequestTicket.new(double(defaults.merge(opts)))
      end

      subject { ticket }
      its(:tags) { should include("taxonomy_new_topic") }
      its(:subject) { should eq("") }

      context "with a title" do
        subject { ticket(title: "ABC") }
        its(:subject) { should eq("ABC") }
      end
    end
  end
end
