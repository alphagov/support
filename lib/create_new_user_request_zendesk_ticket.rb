require 'zendesk_ticket'
require 'labelled_snippet'

class CreateNewUserRequestZendeskTicket < ZendeskTicket
  def subject
    "Create new user"
  end

  def tags
    super + ["new_user"] + inside_government_tag_if_needed
  end

  protected
  def comment_snippets
    [ 
      LabelledSnippet.new(on: @request, field: :formatted_tool_role,
                                       label: "Tool/Role"),
      LabelledSnippet.new(on: @request.requested_user, field: :name,
                                                      label: "Requested user's name"),
      LabelledSnippet.new(on: @request.requested_user, field: :email,
                                                      label: "Requested user's email"),
      LabelledSnippet.new(on: @request.requested_user, field: :job,
                                                      label: "Requested user's job title"),
      LabelledSnippet.new(on: @request.requested_user, field: :phone,
                                                      label: "Requested user's phone number"),
      LabelledSnippet.new(on: @request, field: :additional_comments)
    ]
  end
end