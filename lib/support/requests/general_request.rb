require 'support/requests/request'

module Support
  module Requests
    class GeneralRequest < Request
      attr_accessor :title, :url, :additional, :user_agent

      def self.label
        "General"
      end
    end
  end
end
