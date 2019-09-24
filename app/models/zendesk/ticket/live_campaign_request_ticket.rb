module Zendesk
  module Ticket
    class LiveCampaignRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Live Campaign"
      end

      def tags
        super + %w[live_campaign]
      end

    protected

      def comment_snippets
        [
            Zendesk::LabelledSnippet.new(on: @request.live_campaign, field: :title,
                                label: "Campaign Title"),
            Zendesk::LabelledSnippet.new(on: @request.live_campaign, field: :proposed_url,
                                label: "Campaign URL"),
            Zendesk::LabelledSnippet.new(on: @request.live_campaign, field: :description,
                                label: "Details of requested support"),
            Zendesk::LabelledSnippet.new(on: @request.live_campaign, field: :time_constraints,
                                label: "Are there any time constraints for this request?"),
            Zendesk::LabelledSnippet.new(on: @request.live_campaign, field: :reason_for_dates,
                                label: "Reason for the above dates?"),
        ]
      end
    end
  end
end
