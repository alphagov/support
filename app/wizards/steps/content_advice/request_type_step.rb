module Steps
  module ContentAdvice
    class RequestTypeStep
      include DfE::Wizard::Step

      attribute :type, :string

      validates :type, presence: true

      def self.permitted_params
        %i[type]
      end
    end
  end
end
