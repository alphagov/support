require 'active_model/model'
require 'support/requests/with_requester'

module Support
  module Requests
    class Request
      include ActiveModel::Model

      def initialize(attributes = {})
        self.requester = Requester.new

        super
      end

      include WithRequester
    end
  end
end
