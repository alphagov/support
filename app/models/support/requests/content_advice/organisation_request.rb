# frozen_string_literal: true

module Support
  module Requests
    module ContentAdvice
      class OrganisationRequest < Support::Requests::ContentAdviceRequest
        attr_accessor :org_name

        validates :org_name, presence: true

        def initialize(attributes = {})
          super(attributes)
        end

        def title
          "#{org_name} - Organisation Request"
        end

        def details
          "[Organisation name] #{org_name}"
        end

        def self.link
          "/content_advice/organisation_request/new"
        end

        def self.label
          "Organisation Request"
        end

        def self.description
          "This is the description for the org request form"
        end
      end
    end
  end
end
