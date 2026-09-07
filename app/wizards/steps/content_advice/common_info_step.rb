module Steps
  module ContentAdvice
    class CommonInfoStep
      include DfE::Wizard::Step

      attribute :deadline, :string
      attribute :cc_email, :string

      def self.permitted_params
        %i[deadline cc_email]
      end
    end
  end
end
