require "rails_helper"

module Support
  module GDS
    describe UserFacingComponent do
      def component(attrs)
        Support::GDS::UserFacingComponent.new(attrs)
      end

      it { should validate_presence_of(:name) }
      it { should allow_value(name: "gov_uk").for(:name) }

      it "knows whether components are Inside Government-related or not" do
        expect(component(name: "inside_government_publisher", inside_government_related: true)).to be_inside_government_related
        expect(component(name: "gov_uk")).to_not be_inside_government_related
      end
    end
  end
end
