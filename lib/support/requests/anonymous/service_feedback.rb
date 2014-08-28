require 'support/requests/anonymous/anonymous_contact'
require 'support/requests/anonymous/service_feedback_validations'

module Support
  module Requests
    module Anonymous
      class ServiceFeedback < AnonymousContact
        include ServiceFeedbackValidations
        attr_accessible :details, :slug, :service_satisfaction_rating
      end
    end
  end
end
