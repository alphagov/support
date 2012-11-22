require 'zendesk_ticket'
require 'forwardable'
require 'comment_snippet'

class NewFeatureRequestZendeskTicket < ZendeskTicket
  attr_reader :time_constraint

  def initialize(request)
    super(request, nil)
    @requester = request.requester
    @time_constraint = request.time_constraint
  end

  def subject
    "New Feature Request"
  end

  def request_specific_tag
    "new_feature_request"
  end

  # the following methods will be pushed down to the superclass as soon as everything is converted to ActiveModel
  def_delegators :@requester, :name, :email, :organisation, :job

  protected
  def comment_snippets
    [ CommentSnippet.new(@request.requester, :other_organisation),
      CommentSnippet.new(@request, :user_need),
      CommentSnippet.new(@request, :url_of_example),
      CommentSnippet.new(@request.time_constraint, :time_constraint_reason) ]
  end
end