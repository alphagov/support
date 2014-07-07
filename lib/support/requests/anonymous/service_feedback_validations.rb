module Support
  module Requests
    module Anonymous
      module ServiceFeedbackValidations
        def self.included(base)
          base.validates_presence_of :slug, :service_satisfaction_rating
          base.validates :details, length: { maximum: 2 ** 16 }
          base.validates_inclusion_of :service_satisfaction_rating, in: (1..5).to_a
        end
      end
    end
  end
end
