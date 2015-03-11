require 'support/requests/anonymous/anonymous_contact'
require 'support/requests/anonymous/service_feedback_validations'

module Support
  module Requests
    module Anonymous
      class ServiceFeedback < AnonymousContact
        include ServiceFeedbackValidations
      end
    end
  end
end
