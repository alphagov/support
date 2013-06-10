require 'shared/request'
require 'support/requests/with_time_constraint'
require 'shared/with_request_context'

module Support
  module Requests
    class ContentChangeRequest < Request
      include WithTimeConstraint
      include WithRequestContext

      attr_accessor :title, :details_of_change, :url, :related_urls
      validates_presence_of :details_of_change

      def self.label
        "Content change"
      end
    end
  end
end