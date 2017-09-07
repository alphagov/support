require 'rails_helper'

describe AnonymousFeedbackApiResponse do
  describe "#beyond_last_page?" do
    context "with 0 pages" do
      let(:api_response) {
        AnonymousFeedbackApiResponse.new(pages: 0)
      }

      it "isn't beyond last page" do
        expect(api_response).not_to be_beyond_last_page
      end
    end

    context "with pages" do
      context "within page limits" do
        let(:api_response) {
          AnonymousFeedbackApiResponse.new(
            pages: 100,
            current_page: 100
          )
        }

        it "isn't beyond last page" do
          expect(api_response).not_to be_beyond_last_page
        end
      end

      context "outside of page limits" do
        let(:api_response) {
          AnonymousFeedbackApiResponse.new(
            pages: 1,
            current_page: 2
          )
        }

        it "is beyond last page" do
          expect(api_response).to be_beyond_last_page
        end
      end
    end
  end
end
