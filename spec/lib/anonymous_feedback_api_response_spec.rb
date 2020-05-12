require "rails_helper"

describe AnonymousFeedbackApiResponse do
  describe "#beyond_last_page?" do
    context "with 0 pages" do
      let(:api_response) do
        described_class.new(pages: 0)
      end

      it "isn't beyond last page" do
        expect(api_response).not_to be_beyond_last_page
      end
    end

    context "with pages" do
      context "within page limits" do
        let(:api_response) do
          described_class.new(pages: 100, current_page: 100)
        end

        it "isn't beyond last page" do
          expect(api_response).not_to be_beyond_last_page
        end
      end

      context "outside of page limits" do
        let(:api_response) do
          described_class.new(pages: 1, current_page: 2)
        end

        it "is beyond last page" do
          expect(api_response).to be_beyond_last_page
        end
      end
    end
  end
end
