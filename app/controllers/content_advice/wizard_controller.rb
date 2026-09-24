# frozen_string_literal: true

module ContentAdvice
  class WizardController < ApplicationController
    before_action :set_wizard

    layout "design_system"

    def new; end

    def create
      if @wizard.save_current_step
        redirect_to @wizard.next_step_path
      else
        render :new
      end
    end

  private

    def set_wizard
      repository = Repositories::SupportApiRepository.new(draft_request_reference)
      state_store = StateStores::ContentAdviceStore.new(repository:)

      @wizard = ContentAdviceWizard.new(
        current_step: controller_name.to_sym,
        current_step_params: params,
        state_store:,
      )
    end

    def draft_request_reference
      ref = session[:support_app_reference]

      if ref.blank?
        ref = SecureRandom.alphanumeric(16)
        session[:support_app_reference] = ref
      end

      session[:support_app_reference]
    end
  end
end
