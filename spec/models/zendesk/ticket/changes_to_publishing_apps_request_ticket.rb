require 'spec_helper'
require 'zendesk/ticket/changes_to_publishing_apps_request_ticket'

module Zendesk
  module Ticket
    describe ChangesToPublishingAppsRequestTicket do
      def ticket(opts)
        defaults = { requester: nil, title: nil }
        ChangesToPublishingAppsRequestTicket.new(double(defaults.merge(opts)))
      end

      subject { ticket }
      its(:tags) { should include("new_feature_request") }
      its(:subject) { should eq("") }

      context "with a title" do
        subject { ticket(title: "ABC") }
        its(:subject) { should eq("ABC") }
      end
    end
  end
end
