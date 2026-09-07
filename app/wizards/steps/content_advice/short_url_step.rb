module Steps
  module ContentAdvice
    class ShortUrlStep
      include DfE::Wizard::Step

      attribute :from_url, :string
      attribute :to_url, :string
      attribute :reason, :string

      validates :from_url, :to_url, presence: true

      def self.permitted_params
        %i[from_url to_url reason]
      end
    end
  end
end
