require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class LiveCampaignRequestTicket < ZendeskTicket
      def subject
        "Live Campaign"
      end

      def tags
        super + ["live_campaign"]
      end

    protected

      def comment_snippets
        [
            LabelledSnippet.new(on: @request.live_campaign, field: :title,
                                label: "Campaign Title"),
            LabelledSnippet.new(on: @request.live_campaign, field: :proposed_url,
                                label: "Campaign URL"),
            LabelledSnippet.new(on: @request.live_campaign, field: :description,
                                label: "Details of requested support"),
            LabelledSnippet.new(on: @request.live_campaign, field: :time_constraints,
                                label: "Are there any time constraints for this request?"),
            LabelledSnippet.new(on: @request.live_campaign, field: :reason_for_dates,
                                label: "Reason for the above dates?")
        ]
      end
    end
  end
end
