require 'zendesk_ticket'
require 'forwardable'
require 'comment_snippet'

class NewFeatureRequestZendeskTicket < ZendeskTicket
  attr_reader :time_constraint

  def initialize(request)
    super(request, nil)
    @requester = request.requester
  end

  def subject
    "New Feature Request"
  end

  def tags
    ["new_feature_request"]
  end

  # the following methods will be pushed down to the superclass as soon as everything is converted to ActiveModel
  def_delegators :@requester, :name, :email, :organisation, :job

  protected
  def comment_snippets
    [ CommentSnippet.new(on: @request.requester,       field: :other_organisation),
      CommentSnippet.new(on: @request,                 field: :user_need),
      CommentSnippet.new(on: @request,                 field: :url_of_example),
      CommentSnippet.new(on: @request.time_constraint, field: :time_constraint_reason) ]
  end
end