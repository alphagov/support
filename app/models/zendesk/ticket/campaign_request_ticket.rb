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
          LabelledSnippet.new(on: @request.campaign, field: :title, label: "Campaign title"),
          LabelledSnippet.new(on: @request.campaign, field: :other_dept_or_agency,
                                                     label: "Other department(s) or agencies running the campaign (if any)"),
          LabelledSnippet.new(on: @request.campaign, field: :signed_campaign,
                                                     label: "Head of Digital who signed off the campaign"),
          LabelledSnippet.new(on: @request.campaign, field: :start_date,
                                                     label: "Start date"),
          LabelledSnippet.new(on: @request.campaign, field: :end_date,
                                                     label: "Campaign end date / review date (within 6 months of launch)"),
          LabelledSnippet.new(on: @request.campaign, field: :description,
                                                     label: "Campaign description"),
          LabelledSnippet.new(on: @request.campaign, field: :call_to_action,
                                                     label: "Call to action"),
          LabelledSnippet.new(on: @request.campaign, field: :success_measure,
                                                     label: "How will you measure success?"),
          LabelledSnippet.new(on: @request.campaign, field: :proposed_url,
                                                     label: "Proposed URL (in the form of xxxxx.campaign.gov.uk)"),
          LabelledSnippet.new(on: @request.campaign, field: :site_metadescription,
                                                     label: "Site metadescription (appears in search results)"),
          LabelledSnippet.new(on: @request.campaign, field: :cost_of_campaign,
                                                     label: "Cost of campaign"),
          LabelledSnippet.new(on: @request,          field: :additional_comments)
        ]
      end
    end
  end
end
