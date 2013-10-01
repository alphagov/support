require 'support/requests/request'

module Support
  module Requests
    module Anonymous
      class LongFormContact < NamedContact
        DEFAULTS = { requester: Requester.anonymous }

        def initialize(options = {})
          super(DEFAULTS.merge(options))
        end
      end
    end
  end
end
