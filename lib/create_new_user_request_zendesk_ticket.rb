require 'zendesk_ticket'
require 'forwardable'
require 'comment_snippet'

class CreateNewUserRequestZendeskTicket < ZendeskTicket
  def initialize(request)
    super(request, nil)
    @requester = request.requester
  end

  def subject
    "Create new user"
  end

  def request_specific_tag
    "new_user"
  end

  # the following methods will be pushed down to the superclass as soon as everything is converted to ActiveModel
  def_delegators :@requester, :name, :email, :organisation, :job

  protected
  def comment_snippets
    [ CommentSnippet.new(on: @request.requester, field: :other_organisation),
      CommentSnippet.new(on: @request, field: :user_name),
      CommentSnippet.new(on: @request, field: :user_email),
      CommentSnippet.new(on: @request, field: :additional_comments) ]
  end
end