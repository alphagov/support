module Steps
  module ContentAdvice
    class ReviewStep
      include DfE::Wizard::Step

      def self.permitted_params
        []
      end

      def next_button_text
        "Confirm"
      end
    end
  end
end
