require 'support/requests/request'

module Support
  module Requests
    class ContentAdviceRequest < Request
      attr_accessor :title

      def self.label
        "Content advice"
      end

      def self.description
        "Ask for advice and guidance on Departments and Policy content"
      end
    end
  end
end
