require 'zendesk_ticket'
require 'labelled_snippet'

class TechnicalFaultReportZendeskTicket < ZendeskTicket
  def subject
    "Technical fault report"
  end

  def tags
    super + ["technical_fault", fault_context_tag] + inside_government_tag_if_needed
  end

  protected
  def fault_context_tag
    "fault_with_#{@request.fault_context.name}"
  end

  def comment_snippets
    [
      LabelledSnippet.new(on: @request.fault_context, field: :formatted_name,
                                                      label: "Location of fault"),
    ]
  end
end