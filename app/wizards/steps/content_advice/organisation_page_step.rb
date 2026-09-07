module Steps
  module ContentAdvice
    class OrganisationPageStep
      include DfE::Wizard::Step

      attribute :org_name, :string

      validates :org_name, presence: true

      def self.permitted_params
        %i[org_name]
      end
    end
  end
end
