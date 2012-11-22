require 'zendesk_ticket'
require 'forwardable'
require 'comment_snippet'

class GeneralRequestZendeskTicket < ZendeskTicket
  def initialize(request)
    super(request, nil)
    @requester = request.requester
  end

  def subject
    "Govt Agency General Issue"
  end

  def request_specific_tag
    "govt_agency_general"
  end

  # the following methods will be pushed down to the superclass as soon as everything is converted to ActiveModel
  def_delegators :@requester, :name, :email, :organisation, :job

  protected
  def comment_snippets
    [ CommentSnippet.new(on: @request.requester, field: :other_organisation),
      CommentSnippet.new(on: @request, field: :url),
      CommentSnippet.new(on: @request, field: :user_agent),
      CommentSnippet.new(on: @request, field: :additional) ]
  end
end