require "rails_helper"

module Support
  module GDS
    describe UserFacingComponent do
      def component(attrs)
        Support::GDS::UserFacingComponent.new(attrs)
      end

      it { should validate_presence_of(:name) }
      it { should allow_value(name: "gov_uk").for(:name) }
    end
  end
end
