require 'zendesk_ticket'
require 'labelled_snippet'

class TechnicalFaultReportZendeskTicket < ZendeskTicket
  def subject
  end

  def tags
  end

  protected
  def comment_snippets
    []
  end
end