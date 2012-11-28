require 'zendesk_ticket'
require 'forwardable'
require 'comment_snippet'

class CampaignRequestZendeskTicket < ZendeskTicket
  def initialize(request)
    super(request, nil)
    @requester = request.requester
  end

  def subject
    "Campaign"
  end

  def tags
    ["campaign"]
  end

  # the following methods will be pushed down to the superclass as soon as everything is converted to ActiveModel
  def_delegators :@requester, :name, :email, :organisation, :job

  protected
  def comment_snippets
    [ CommentSnippet.new(on: @request.requester, field: :other_organisation),
      CommentSnippet.new(on: @request.campaign, field: :title, 
                                                label: "Campaign title"),
      CommentSnippet.new(on: @request.campaign, field: :erg_reference_number,
                                                label: "ERG reference number"),
      CommentSnippet.new(on: @request.campaign, field: :start_date),
      CommentSnippet.new(on: @request.campaign, field: :description),
      CommentSnippet.new(on: @request.campaign, field: :affiliated_group_or_company),
      CommentSnippet.new(on: @request.campaign, field: :info_url,
                                                label: "URL with more information"),
      CommentSnippet.new(on: @request, field: :additional_comments) ]
  end
end