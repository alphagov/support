require 'spec_helper'
require 'zendesk/ticket/changes_to_publishing_apps_request_ticket'

module Zendesk
  module Ticket
    describe ChangesToPublishingAppsRequestTicket do
      def ticket(opts)
        defaults = { requester: nil, title: nil }
        ChangesToPublishingAppsRequestTicket.new(double(defaults.merge(opts)))
      end

      context "an inside government request" do
        subject { ticket(inside_government_related?: true) }
        its(:tags) { should include("new_feature_request", "inside_government") }
        its(:subject) { should eq("New Feature Request") }
      end

      context "a mainstream request" do
        subject { ticket(inside_government_related?: false) }
        its(:tags) { should include("new_need_request") }
        its(:subject) { should eq("New Need Request") }

        context "with a title" do
          subject { ticket(title: "ABC", inside_government_related?: false) }
          its(:subject) { should eq("ABC - New Need Request") }
        end
      end
    end
  end
end
