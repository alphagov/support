require 'zendesk_ticket'
require 'labelled_snippet'

class AnalyticsRequestZendeskTicket < ZendeskTicket
  def subject
    "Request for analytics"
  end

  def tags
    super + ["analytics"]
  end

  protected
  def comment_snippets
    [
      LabelledSnippet.new(on: @request,               field: :formatted_request_context,
                                                      label: "Which part of GOV.UK is this about?"),
      LabelledSnippet.new(on: @request.needed_report, field: :reporting_period),
      LabelledSnippet.new(on: @request.needed_report, field: :pages_or_sections,
                                                      label: "Requested pages/sections"),
      LabelledSnippet.new(on: @request,               field: :justification_for_needing_report),
      LabelledSnippet.new(on: @request.needed_report, field: :non_standard_requirements,
                                                      label: "More detailed analysis needed?"),
      LabelledSnippet.new(on: @request.needed_report, field: :formatted_frequency,
                                                      label: "Reporting frequency"),
    ]
  end
end