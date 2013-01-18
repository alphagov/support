require 'forwardable'
require 'date'
require 'active_support'
require 'snippet_collection'
require 'labelled_snippet'

class ZendeskTicket
  extend Forwardable

  def initialize(request)
    @request = request
    @requester = request.requester
  end

  def_delegators :@requester, :email, :name, :collaborator_emails

  def comment
    SnippetCollection.new(comment_snippets).to_s
  end

  def not_before_date
    if has_value?(:time_constraint) and has_value?(:not_before_date, @request.time_constraint)
      @request.time_constraint.not_before_date
    else
      nil
    end
  end

  def needed_by_date
    if has_value?(:time_constraint) and has_value?(:needed_by_date, @request.time_constraint)
      @request.time_constraint.needed_by_date
    else
      nil
    end
  end

  def tags
    ["govt_form"]
  end

  def inside_government_tag_if_needed
    @request.inside_government_related? ? ["inside_government"] : []
  end

  def to_s
    SnippetCollection.new(base_attribute_snippets + comment_snippets).to_s
  end

  private
  def base_attribute_snippets
    [
      LabelledSnippet.new(on: @requester, field: :name, label: "Requester name"),
      LabelledSnippet.new(on: @requester, field: :email, label: "Requester email"),
      LabelledSnippet.new(on: @requester, field: :collaborator_emails),
      LabelledSnippet.new(on: self, field: :tags),
    ]
  end

  def has_value?(param, target = nil)
    target ||= @request
    target.respond_to?(param) and not target.send(param).blank?
  end
end

