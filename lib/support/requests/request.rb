require 'active_model/tableless_model'
require 'support/requests/with_requester'

module Support
  module Requests
    class Request < ActiveModel::TablelessModel
      def initialize(attributes = {})
        self.requester = Requester.new

        super
      end

      include WithRequester
    end
  end
end
