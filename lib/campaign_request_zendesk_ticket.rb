require 'zendesk_ticket'
require 'comment_snippet'

class CampaignRequestZendeskTicket < ZendeskTicket
  def subject
    "Campaign"
  end

  def tags
    ["campaign"]
  end

  protected
  def comment_snippets
    [
      CommentSnippet.new(on: @request.campaign, field: :title, 
                                                label: "Campaign title"),
      CommentSnippet.new(on: @request.campaign, field: :erg_reference_number,
                                                label: "ERG reference number"),
      CommentSnippet.new(on: @request.campaign, field: :start_date),
      CommentSnippet.new(on: @request.campaign, field: :description),
      CommentSnippet.new(on: @request.campaign, field: :affiliated_group_or_company),
      CommentSnippet.new(on: @request.campaign, field: :info_url,
                                                label: "URL with more information"),
      CommentSnippet.new(on: @request, field: :additional_comments)
    ]
  end
end