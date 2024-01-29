require "rails_helper"

module Support
  module Requests
    describe CreateNewUserRequest do
      def request(options = {})
        described_class.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:requester) }

      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }

      it { should allow_value("ab@c.com").for(:email) }
      it { should_not allow_value("ab").for(:email) }

      it "does not have format error if email is blank" do
        expect(request(email: "").errors[:email]).not_to include("is invalid")
      end

      it { should allow_value("yes").for(:requires_additional_access) }
      it { should allow_value("no").for(:requires_additional_access) }
      it { should_not allow_value("").for(:requires_additional_access) }
      it { should_not allow_value("invalid").for(:requires_additional_access) }

      it "maps the organisation 'None' option to the blank option" do
        expect(request(organisation: "None").organisation).to be_blank
      end

      it "leaves the organisation blank option unchanged" do
        expect(request(organisation: "").organisation).to be_blank
      end

      it "leaves other organisation options unchanged" do
        expect(request(organisation: "Cabinet Office (CO)").organisation).to eq("Cabinet Office (CO)")
      end

      it "does not allow additional_comments to be blank if requires_additional_access is 'yes'" do
        expect(request(requires_additional_access: "yes", additional_comments: "").errors[:additional_comments]).to include(error_message_for(:additional_comments, :blank))
      end

      it "allows additional_comments to be blank if requires_additional_access is 'no'" do
        expect(request(requires_additional_access: "no", additional_comments: "").errors[:additional_comments]).not_to include(error_message_for(:additional_comments, :blank))
      end

      it "returns original additional_comments if requires_additional_access is 'yes'" do
        expect(request(requires_additional_access: "yes", additional_comments: "original").additional_comments).to eq("original")
      end

      it "returns blank additional_comments if requires_additional_access is 'no'" do
        expect(request(requires_additional_access: "no", additional_comments: "original").additional_comments).to be_blank
      end

      it "provides formatted action" do
        expect(request.formatted_action).to eq("Create a new user account")
      end

      def error_message_for(attribute_name, validation_type)
        I18n.t!("activemodel.errors.models.support/requests/create_new_user_request.attributes.#{attribute_name}.#{validation_type}")
      end
    end
  end
end
