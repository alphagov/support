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
      state_store = StateStores::ContentAdviceStore.new(
        repository: DfE::Wizard::Repository::Session.new(
          session:,
          key: :content_advice,
        ),
      )

      @wizard = ContentAdviceWizard.new(
        current_step: controller_name.to_sym,
        current_step_params: params,
        state_store:,
      )
    end
  end
end
