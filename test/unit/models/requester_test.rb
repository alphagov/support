require 'test_helper'

class RequesterTest < Test::Unit::TestCase
  should validate_presence_of(:email)

  should validate_presence_of(:name)

  should allow_value("ab@c.com").for(:email)
  should_not allow_value("ab").for(:email)

  should allow_value("").for(:collaborator_emails)
  should allow_value("ab@c.com").for(:collaborator_emails)
  should allow_value("ab@c.com, de@f.com").for(:collaborator_emails)
  should_not allow_value("ab, de@f.com").for(:collaborator_emails)

  should "have an empty list of collaborator emails if not set" do
    assert_equal [], Requester.new.collaborator_emails
  end
end