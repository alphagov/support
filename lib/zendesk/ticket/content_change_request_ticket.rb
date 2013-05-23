require 'zendesk_ticket'
require 'labelled_snippet'

module Zendesk
  module Ticket
    class ContentChangeRequestTicket < ZendeskTicket
      def subject
        unless @request.title.nil? or @request.title.empty?
          "#{@request.title} - Content change request"
        else
          "Content change request"
        end
      end

      def tags
        super + ["content_amend"] + inside_government_tag_if_needed
      end

      protected
      def comment_snippets
        [ 
          LabelledSnippet.new(on: @request,                 field: :formatted_request_context,
                                                           label: "Which part of GOV.UK is this about?"),
          LabelledSnippet.new(on: @request,                 field: :url,
                                                           label: "URL of content to be changed"),
          LabelledSnippet.new(on: @request,                 field: :related_urls,
                                                           label: "Related URLs"),
          LabelledSnippet.new(on: @request,                 field: :details_of_change,
                                                           label: "Details of what should be added, amended or removed"),
          LabelledSnippet.new(on: @request.time_constraint, field: :time_constraint_reason)
        ]
      end
    end
  end
end