require 'zendesk_ticket'
require 'forwardable'
require 'comment_snippet'

class GeneralRequestZendeskTicket < ZendeskTicket
  def_delegators :@requester, :name, :email, :organisation, :job

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

  # the following method will be pushed down to the superclass as soon as everything is converted to ActiveModel
  def comment
    applicable_snippets = comment_snippets.select(&:applies?)
    applicable_snippets.collect(&:to_s).join("\n\n")
  end

  def phone
    if @request.requester.phone?
      remove_space_from_phone_number(@requester.phone)
    else
      nil
    end
  end

  protected
  def comment_snippets
    [ CommentSnippet.new(@request.requester, :other_organisation),
      CommentSnippet.new(@request, :url),
      CommentSnippet.new(@request, :user_agent),
      CommentSnippet.new(@request, :additional) ]
  end
end