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
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :signed_campaign,
            label: "Name of the Head of Digital Communications who signed off the campaign website application",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :start_date,
            label: "Start date of campaign site",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :end_date,
            label: "Proposed end date of campaign site",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :development_start_date,
            label: "Site build to commence on",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :performance_review_contact_email,
            label: "Contact email/s for website performance review every 6 months",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :government_theme,
            label: "Which of the current Government Communications Plan priority themes does this campaign website support and how?",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :description,
            label: "Campaign description",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :call_to_action,
            label: "Call to action",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :success_measure,
            label: "How will you measure success?",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :proposed_url,
            label: "Proposed URL (in the form of xxxxx.campaign.gov.uk)",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :site_title,
            label: "Site title",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :site_tagline,
            label: "Site tagline",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :site_metadescription,
            label: "Site metadescription (appears in search results)",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :cost_of_campaign,
            label: "Site build budget / costs (and overall campaign cost, if applicable)",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :hmg_code,
            label: "HMG code: from approved AMC technical cases. Format: HMGXX-XXX (If not applicable enter n/a)",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :strategic_planning_code,
            label: "Strategic Planning Code: from strategic planning phase. Format: CSBXX-XXX (If not applicable enter n/a)",
          ),
          Zendesk::LabelledSnippet.new(on: @request, field: :additional_comments),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :has_read_guidance_confirmation,
            label: "I/We have read the GCS guidance on campaign websites and accept the requirements for a Campaign Platform website",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :has_read_oasis_guidance_confirmation,
            label: "I/We have followed the GCS guidance for OASIS planning and are using the mandatory GCS OASIS template",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :full_responsibility_confirmation,
            label: "I/We will take full responsibility for all aspects of managing and resourcing this campaign site from Discovery stage to site build/content development, to site closure",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :accessibility_confirmation,
            label: "I/We will ensure the site meets all government web accessibility standards, and that it will be tested and the Accessibility Statement completed before final review",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request.campaign,
            field: :cookie_and_privacy_notice_confirmation,
            label: "I/We agree to take responsibility to maintain and up-date the Cookie Notice and Privacy Notice as necessary, with our Data Protection Officer",
          ),
        ]
      end
    end
  end
end
