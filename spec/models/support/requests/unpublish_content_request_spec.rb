require 'spec_helper'
require 'support/requests/unpublish_content_request'

module Support
  module Requests
    describe UnpublishContentRequest do
      def request(opts = {})
        UnpublishContentRequest.new(opts).tap(&:valid?)
      end

      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:reason_for_unpublishing) }
      it { should validate_presence_of(:urls) }

      it { should allow_value("abc").for(:further_explanation) }
      it { should allow_value("abc").for(:redirect_url) }

      it { should allow_value("1").for(:automatic_redirect) }
      it { should allow_value("0").for(:automatic_redirect) }
      it { should allow_value(nil).for(:automatic_redirect) }
      it { should_not allow_value("xxx").for(:automatic_redirect) }

      it "provides options for the unpublishing reason" do
        expect(request.reason_for_unpublishing_options.size).to eq(3)
      end

      it "provides formatted reason for unpublishing content" do
        expect(request(reason_for_unpublishing: "published_in_error").formatted_reason_for_unpublishing).to eq("Published in error")
      end

      it "validates presence of the redirect url if the reason for publishing involves another page" do
        expect(request(reason_for_unpublishing: "duplicate_publication").errors[:redirect_url]).to_not be_empty
        expect(request(reason_for_unpublishing: "superseded_publication").errors[:redirect_url]).to_not be_empty

        expect(request(reason_for_unpublishing: "published_in_error").errors[:redirect_url]).to be_empty
      end

      it "specifies whether the redirect is automatic or not if the reason involves another page" do
        expect(request(reason_for_unpublishing: "duplicate_publication", automatic_redirect: nil).errors[:automatic_redirect]).to_not be_empty
        expect(request(reason_for_unpublishing: "superseded_publication", automatic_redirect: nil).errors[:automatic_redirect]).to_not be_empty

        expect(request(reason_for_unpublishing: "published_in_error", automatic_redirect: nil).errors[:automatic_redirect]).to be_empty
      end

      it "has automatic redirection selected by default" do
        expect(request.automatic_redirect).to_not be_nil
      end
    end
  end
end
