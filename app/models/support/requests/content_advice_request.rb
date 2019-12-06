require "support/requests/with_time_constraint"
require "active_support/core_ext"

module Support
  module Requests
    class ContentAdviceRequest < Request
      include WithTimeConstraint

      attr_accessor :title, :details, :urls, :contact_number

      validates :details, presence: true

      def initialize(attrs = {})
        self.time_constraint = TimeConstraint.new

        super
      end

      def self.label
        "Content advice and help"
      end

      def self.description
        "Ask for help or advice on any content problems. Request short URLs, topical event pages, groups or manuals."
      end
    end
  end
end
