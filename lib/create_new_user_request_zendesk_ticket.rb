require 'zendesk_ticket'
require 'comment_snippet'

class CreateNewUserRequestZendeskTicket < ZendeskTicket
  def subject
    "Create new user"
  end

  def request_specific_tags
    ["new_user"] + inside_government_tag_if_needed
  end

  protected
  def comment_snippets
    [ 
      CommentSnippet.new(on: @request, field: :formatted_tool_role,
                                       label: "Tool/Role"),
      CommentSnippet.new(on: @request.requested_user, field: :name,
                                                      label: "Requested user's name"),
      CommentSnippet.new(on: @request.requested_user, field: :email,
                                                      label: "Requested user's email"),
      CommentSnippet.new(on: @request.requested_user, field: :job,
                                                      label: "Requested user's job title"),
      CommentSnippet.new(on: @request.requested_user, field: :phone,
                                                      label: "Requested user's phone number"),
      CommentSnippet.new(on: @request, field: :additional_comments)
    ]
  end
end