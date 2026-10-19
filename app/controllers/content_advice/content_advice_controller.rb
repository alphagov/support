module ContentAdvice
  class ContentAdviceController < ApplicationController
    layout "design_system"
    def index
      @accessible_sections, @inaccessible_sections =
        Support::Navigation::ContentAdviceSections.new(current_user).partition(&:accessible?)
    end
  end
end
