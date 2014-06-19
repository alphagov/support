require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class CampaignRequestTicket < ZendeskTicket
      def subject
        "Campaign"
      end

      def tags
        super + ["campaign"]
      end

      protected
      def comment_snippets
        [
          LabelledSnippet.new(on: @request.campaign, field: :title, 
                                                     label: "Campaign title"),
          LabelledSnippet.new(on: @request.campaign, field: :erg_reference_number,
                                                     label: "ERG reference number"),
          LabelledSnippet.new(on: @request.campaign, field: :start_date),
          LabelledSnippet.new(on: @request.campaign, field: :description),
          LabelledSnippet.new(on: @request.campaign, field: :affiliated_group_or_company),
          LabelledSnippet.new(on: @request.campaign, field: :info_url,
                                                     label: "URL with more information"),
          LabelledSnippet.new(on: @request,          field: :additional_comments)
        ]
      end
    end
  end
end
