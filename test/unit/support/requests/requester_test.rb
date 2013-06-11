require 'test_helper'
require 'support/requests/requester'

module Support
  module Requests
    class RequesterTest < Test::Unit::TestCase
      should validate_presence_of(:email)

      should validate_presence_of(:name)

      should allow_value("ab@c.com").for(:email)
      should allow_value("ab@ c.com").for(:email)
      should allow_value("ab @c.com").for(:email)
      should allow_value("ab@c.com ").for(:email)
      should allow_value(" ab@c.com").for(:email)
      should_not allow_value("ab").for(:email)

      should allow_value("").for(:collaborator_emails)
      should allow_value("ab@c.com").for(:collaborator_emails)
      should allow_value("ab@c.com, de@f.com").for(:collaborator_emails)
      should_not allow_value("ab, de@f.com").for(:collaborator_emails)

      should "remove all whitespace from the email" do
        assert_equal "ab@c.com", Requester.new(email: " ab@c.com").email
        assert_equal "ab@c.com", Requester.new(email: "ab@c.com ").email
        assert_equal "ab@c.com", Requester.new(email: "ab @c.com").email
        assert_equal "ab@c.com", Requester.new(email: "ab@ c.com").email
      end

      should "have an empty list of collaborator emails if not set" do
        assert_equal [], Requester.new.collaborator_emails
      end

      should "remove the requester from the collaborators (as Zendesk doesn't allow this)" do
        requester = Requester.new(collaborator_emails: "a@b.com, requester@x.com, c@d.com")
        requester.email = "requester@x.com"
        assert_equal ["a@b.com", "c@d.com"], requester.collaborator_emails
      end
    end
  end
end