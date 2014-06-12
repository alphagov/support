require 'support/requests/anonymous/service_feedback'

FactoryGirl.define do
  factory :service_feedback, class: Support::Requests::Anonymous::ServiceFeedback do
    javascript_enabled true
    slug "apply-carers-allowance"
    service_satisfaction_rating 5
  end
end
