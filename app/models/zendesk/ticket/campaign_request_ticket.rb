module Zendesk
  module Ticket
    class CampaignRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Campaign"
      end

      def tags
        super + ["campaign"]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :title, label: "Campaign title"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :other_dept_or_agency,
                                                     label: "Other department(s) or agencies running the campaign (if any)"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :signed_campaign,
                                                     label: "Head of Digital who signed off the campaign"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :start_date,
                                                     label: "Start date"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :end_date,
                                                     label: "Campaign end date / review date (within 6 months of launch)"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :description,
                                                     label: "Campaign description"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :call_to_action,
                                                     label: "Call to action"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :success_measure,
                                                     label: "How will you measure success?"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :proposed_url,
                                                     label: "Proposed URL (in the form of xxxxx.campaign.gov.uk)"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :site_metadescription,
                                                     label: "Site metadescription (appears in search results)"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :cost_of_campaign,
                                                     label: "Cost of campaign"),
          Zendesk::LabelledSnippet.new(on: @request,          field: :additional_comments)
        ]
      end
    end
  end
end
