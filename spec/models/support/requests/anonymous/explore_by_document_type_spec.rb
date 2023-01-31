require "rails_helper"

module Support
  module Requests
    module Anonymous
      describe ExploreByDocumentType do
        describe "validations" do
          it { should validate_presence_of(:document_type) }

          context "with a `document_type`" do
            let(:document_type) { "smart_answer" }

            it "is valid" do
              expect(ExploreByDocumentType.new(document_type:)).to be_valid
            end
          end

          context "without an `document_type`" do
            it "is not valid" do
              expect(ExploreByDocumentType.new(document_type: nil)).to be_invalid
            end
          end
        end
      end
    end
  end
end
