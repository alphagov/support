require 'rails_helper'

module Support
  module Requests
    describe Requester do
      it { should validate_presence_of(:email) }

      it { should validate_presence_of(:name) }

      it { should allow_value("ab@c.com").for(:email) }
      it { should allow_value("ab@ c.com").for(:email) }
      it { should allow_value("ab @c.com").for(:email) }
      it { should allow_value("ab@c.com ").for(:email) }
      it { should allow_value(" ab@c.com").for(:email) }
      it { should_not allow_value("ab").for(:email) }

      it { should allow_value("").for(:collaborator_emails) }
      it { should allow_value("ab@c.com").for(:collaborator_emails) }
      it { should allow_value("ab@c.com, de@f.com").for(:collaborator_emails) }
      it { should_not allow_value("ab, de@f.com").for(:collaborator_emails) }

      it "removes all whitespace from the email" do
        expect(Requester.new(email: " ab@c.com").email).to eq("ab@c.com")
        expect(Requester.new(email: "ab@c.com ").email).to eq("ab@c.com")
        expect(Requester.new(email: "ab @c.com").email).to eq("ab@c.com")
        expect(Requester.new(email: "ab@ c.com").email).to eq("ab@c.com")
      end

      it "has an empty list of collaborator emails if not set" do
        expect(Requester.new.collaborator_emails).to be_empty
      end

      it "removes the requester from the collaborators (as Zendesk doesn't allow this)" do
        requester = Requester.new(collaborator_emails: "a@b.com, requester@x.com, c@d.com")
        requester.email = "requester@x.com"
        expect(requester.collaborator_emails).to eq(["a@b.com", "c@d.com"])
      end
    end
  end
end
