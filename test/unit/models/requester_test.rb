require 'test_helper'

class RequesterTest < Test::Unit::TestCase
  include TestData

  should validate_presence_of(:name)
  should validate_presence_of(:email)
  should validate_presence_of(:job)
  should validate_presence_of(:organisation).with_message(/information is required/)

  should allow_value("07911111").for(:phone)

  should allow_value("some other dept").for(:other_organisation)

  should allow_value("ab@c.com").for(:email)
  should_not allow_value("ab").for(:email)

  should "not allow a blank other_organisation if the organisation=other_organisation" do
    other_organisation_not_set = {"organisation" => "other_organisation", "other_organisation" => ""}
    request = Requester.new(valid_requester_params.merge(other_organisation_not_set))
    assert !request.valid?
    assert_not_empty request.errors[:other_organisation]
  end
end