require "rails_helper"

module Support
  module Requests
    module Anonymous
      describe ExploreByOrganisation do
        describe "validations" do
          it { should validate_presence_of(:organisation) }

          context "with an `organisation`" do
            let(:org) { "Department of Fair Do's" }

            it "is valid" do
              expect(ExploreByOrganisation.new(organisation: org)).to be_valid
            end
          end

          context "without an `organisation`" do
            it "is not valid" do
              expect(ExploreByOrganisation.new(organisation: nil)).to be_invalid
            end
          end
        end
      end
    end
  end
end
