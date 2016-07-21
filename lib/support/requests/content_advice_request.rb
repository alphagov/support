require 'support/requests/request'
require 'support/requests/with_time_constraint'
require 'active_support/core_ext'

module Support
  module Requests
    class ContentAdviceRequest < Request
      include WithTimeConstraint

      attr_accessor :title, :details, :urls, :contact_number

      validates_presence_of :details

      def initialize(attrs = {})
        self.time_constraint = TimeConstraint.new

        super
      end

      def self.label
        "Content advice and help"
      end

      def self.description
        "Ask for help or advice on any content problems"
      end
    end
  end
end
