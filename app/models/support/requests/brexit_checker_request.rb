require 'active_support/core_ext'

module Support
  module Requests
    class BrexitCheckerRequest < Request
      attr_accessor :action_to_change, :description_of_change

      def self.label
        "Get ready for Brexit checker: change request"
      end

      def self.description
        "Request a change to the Brexit checker"
      end
    end
  end
end
