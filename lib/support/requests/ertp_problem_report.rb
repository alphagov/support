require 'support/requests/request'

module Support
  module Requests
    class ErtpProblemReport < Request
      attr_accessor :url, :additional

      def self.label
        "Report an ERTP problem"
      end
    end
  end
end
