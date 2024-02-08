require "forwardable"
require "date"
require "active_support"

module Zendesk
  class ZendeskTicket
    extend Forwardable

    def initialize(request)
      @request = request
      @requester = request.requester
    end

    def_delegators :@requester, :email, :name, :collaborator_emails

    def comment
      Zendesk::SnippetCollection.new(comment_snippets).to_s
    end

    def not_before_date
      if value?(:time_constraint) && value?(:not_before_date, @request.time_constraint)
        @request.time_constraint.not_before_date
      end
    end

    def needed_by_date
      if value?(:time_constraint) && value?(:needed_by_date, @request.time_constraint)
        @request.time_constraint.needed_by_date
      end
    end

    def not_before_time
      if value?(:time_constraint) && value?(:not_before_time, @request.time_constraint)
        @request.time_constraint.not_before_time
      end
    end

    def needed_by_time
      if value?(:time_constraint) && value?(:needed_by_time, @request.time_constraint)
        @request.time_constraint.needed_by_time
      end
    end

    def time_constraint_reason
      if value?(:time_constraint) && value?(:time_constraint_reason, @request.time_constraint)
        @request.time_constraint.time_constraint_reason
      end
    end

    def tags
      %w[govt_form]
    end

    def to_s
      Zendesk::SnippetCollection.new(base_attribute_snippets + comment_snippets).to_s
    end

    def priority
      "normal"
    end

    def comment_snippets
      []
    end

  protected

    def request_label(attributes)
      Zendesk::LabelledSnippet.new({ on: @request }.merge(attributes))
    end

  private

    def base_attribute_snippets
      [
        Zendesk::LabelledSnippet.new(on: @requester, field: :name, label: "Requester name"),
        Zendesk::LabelledSnippet.new(on: @requester, field: :email, label: "Requester email"),
        Zendesk::LabelledSnippet.new(on: @requester, field: :collaborator_emails),
        Zendesk::LabelledSnippet.new(on: self, field: :tags),
      ]
    end

    def value?(param, target = nil)
      target ||= @request
      target.respond_to?(param) && target.send(param).present?
    end
  end
end
