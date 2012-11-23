require 'zendesk_ticket'
require 'forwardable'
require 'comment_snippet'

class ContentChangeRequestZendeskTicket < ZendeskTicket
  attr_reader :time_constraint

  def initialize(request)
    super(request, nil)
    @requester = request.requester
  end

  def subject
    "Content change request"
  end

  def request_specific_tag
    "content_amend"
  end

  # the following methods will be pushed down to the superclass as soon as everything is converted to ActiveModel
  def_delegators :@requester, :name, :email, :organisation, :job

  protected
  def comment_snippets
    [ CommentSnippet.new(on: @request.requester,       field: :other_organisation),
      CommentSnippet.new(on: @request,                 fields: [:url1, :url2, :url3],
                                                       label: "URl(s) of content to be changed"),
      CommentSnippet.new(on: @request,                 field: :details_of_change,
                                                       label: "Details of what should be added, amended or removed"),
      CommentSnippet.new(on: @request.time_constraint, field: :time_constraint_reason) ]
  end
end