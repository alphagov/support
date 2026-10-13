# frozen_string_literal: true

module Support
  module Requests
    module ContentAdvice
      class ContentDesignHelpRequest < Request
        include WithTimeConstraint

        attr_accessor :title,
                      :advice_needed,
                      :deadline

        validates :title, :advice_needed, :deadline, presence: true

        def initialize(attrs = {})
          self.time_constraint = TimeConstraint.new
          super
        end

        def self.label
          "Get help with content design or publishing on GOV.UK"
        end

        def self.description
          "Ask for help or advice on any content problems."
        end

        def details
          "[Advice needed]\n#{advice_needed}"
        end
      end
    end
  end
end
