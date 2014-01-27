require 'support/requests/anonymous/anonymous_contact'

module Support
  module Requests
    module Anonymous
      class ServiceFeedback < AnonymousContact
        attr_accessible :details, :slug, :service_satisfaction_rating, :url

        validates_presence_of :slug, :service_satisfaction_rating
        validates :details, length: { maximum: 2 ** 16 }
        validates_inclusion_of :service_satisfaction_rating, in: (1..5).to_a
        validates :url, url: true, length: { maximum: 2048 }, allow_nil: true
      end
    end
  end
end
