module Support
  module Requests
    class WhitehallAccountsPermissionsAndTrainingRequest < Request
      def initialize(opts = {})
        super
      end

      def self.label
        "New accounts (Whitehall) and training"
      end

      def self.description
        "Request training and new accounts (Whitehall)"
      end
    end
  end
end
