require 'support/requests/anonymous/anonymous_contact'
require 'support/requests/anonymous/service_feedback_validations'

module Support
  module Requests
    module Anonymous
      class ServiceFeedback < AnonymousContact
        include ServiceFeedbackValidations
        attr_accessible :details, :slug, :service_satisfaction_rating

        def self.transaction_slugs
          uniq.pluck(:slug).sort
        end

        def self.aggregates_by_rating
          zero_defaults = Hash[*(1..5).map {|n| [n, 0] }.flatten]
          select("service_satisfaction_rating, count(*) as cnt").
            group(:service_satisfaction_rating).
            inject(zero_defaults) { |memo, result| memo[result[:service_satisfaction_rating]] = result[:cnt]; memo }
        end

        def self.with_comments_count
          where("details IS NOT NULL").count
        end
      end
    end
  end
end
