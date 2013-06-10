require 'active_model/tableless_model'
require 'support/requests/with_requester'

module Support
  module Requests
    class Request < ActiveModel::TablelessModel
      include WithRequester
    end
  end
end