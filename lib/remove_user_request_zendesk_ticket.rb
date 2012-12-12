require 'zendesk_ticket'
require 'comment_snippet'

class RemoveUserRequestZendeskTicket < ZendeskTicket
  def subject
    "Remove user"
  end

  def tags
    super + ["remove_user"] + inside_government_tag_if_needed
  end

  protected
  def comment_snippets
    [ 
      CommentSnippet.new(on: @request, field: :formatted_tool_role,
                                       label: "Tool/Role"),
      CommentSnippet.new(on: @request, field: :user_name),
      CommentSnippet.new(on: @request, field: :user_email),
      CommentSnippet.new(on: @request, field: :additional_comments)
    ]
  end
end