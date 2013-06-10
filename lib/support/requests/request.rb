require 'support/requests/with_requester'

module Support
  module Requests
    class Request < TablelessModel
      include WithRequester
    end
  end
end