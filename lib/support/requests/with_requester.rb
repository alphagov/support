require 'support/requests/requester'

module Support
  module Requests
    module WithRequester
      def self.included(base)
        base.validates_presence_of :requester
        base.validate do |request|
          if request.requester and not request.requester.valid?
            errors[:base] << "Requester details are either not complete or invalid."
          end
        end
      end
      attr_accessor :requester

      def requester_attributes=(attr)
        self.requester = Requester.new(attr)
      end
    end
  end
end