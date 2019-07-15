module Zendesk
  module Ticket
    class CampaignRequestTicket < Zendesk::ZendeskTicket
      def subject
        "Campaign"
      end

      def tags
        super + %w[campaign]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :type_of_site,
                                                     label: "Are you applying for the campaign platform or a bespoke microsite?"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :signed_campaign,
                                                     label: "Name of the head of digital who signed off the campaign website application"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :start_date,
                                                     label: "Start date of campaign site"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :end_date,
                                                     label: "Proposed end date of campaign site"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :development_start_date,
                                                     label: "Site build to commence on"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :performance_review_contact_email,
                                                     label: "Contact email/s for website performance review every 6 months"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :government_theme,
                                                     label: "Which of the current Government Communications Plan priority themes does this campaign website support and how?"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :description,
                                                     label: "Campaign description"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :call_to_action,
                                                     label: "Call to action"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :success_measure,
                                                     label: "How will you measure success?"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :proposed_url,
                                                     label: "Proposed URL (in the form of xxxxx.campaign.gov.uk or xxxxx.gov.uk)"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :site_title,
                                                     label: 'The short campaign title, approx 1 - 3 words'),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :site_tagline,
                                                     label: 'Explain what this site is about, approx 7 - 8 words'),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :site_metadescription,
                                                     label: 'Approx 20-30 words. A more detailed description or call to action'),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :cost_of_campaign,
                                                     label: "Site build budget / costs (and overall campaign cost, if applicable)"),
          Zendesk::LabelledSnippet.new(on: @request.campaign, field: :ga_contact_email,
                                                     label: "Contact details for Google Analytics leads (Gmail accounts only)"),
          Zendesk::LabelledSnippet.new(on: @request, field: :additional_comments)
        ]
      end
    end
  end
end
