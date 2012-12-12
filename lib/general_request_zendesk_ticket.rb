require 'zendesk_ticket'
require 'comment_snippet'

class GeneralRequestZendeskTicket < ZendeskTicket
  def subject
    "Govt Agency General Issue"
  end

  def request_specific_tags
    ["govt_agency_general"]
  end

  protected
  def comment_snippets
    [ 
      CommentSnippet.new(on: @request, field: :url),
      CommentSnippet.new(on: @request, field: :user_agent),
      CommentSnippet.new(on: @request, field: :additional)
    ]
  end
end