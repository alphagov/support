require 'zendesk_ticket'
require 'comment_snippet'

class ContentChangeRequestZendeskTicket < ZendeskTicket
  def subject
    "Content change request"
  end

  def tags
    ["content_amend"] + inside_government_tag_if_needed
  end

  protected
  def comment_snippets
    [ 
      CommentSnippet.new(on: @request,                 field: :formatted_request_context,
                                                       label: "Which part of GOV.UK is this about?"),
      CommentSnippet.new(on: @request,                 fields: [:url1, :url2, :url3],
                                                       label: "URl(s) of content to be changed"),
      CommentSnippet.new(on: @request,                 field: :details_of_change,
                                                       label: "Details of what should be added, amended or removed"),
      CommentSnippet.new(on: @request.time_constraint, field: :time_constraint_reason)
    ]
  end
end