# frozen_string_literal: true

module ContentAdvice
  class ReviewController < WizardController
    def index
      @steps = @wizard.valid_steps
    end
  end
end
