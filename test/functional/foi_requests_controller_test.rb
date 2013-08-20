require "test_helper"

class FoiRequestsControllerTest < ActionController::TestCase
  def valid_foi_request
    { "foi_request" =>
      {
        "requester" => { "name" => "A", "email" => "ab@c.com" },
        "details"   => "details"
      }
    }
  end

  context "new request" do
    should "acknowledge a valid request" do
      zendesk_has_no_user_with_email("ab@c.com")
      stub_zendesk_ticket_creation
      post :create, valid_foi_request.merge(format: :json)

      assert_response 201
    end

    should "return a JSON array of errors for invalid requests" do
      params = valid_foi_request.tap {|h| h["foi_request"]["requester"]["email"] = "a" }

      post :create, params.merge(format: :json)

      assert_response 400
      refute json_response['errors'].empty?
    end
  end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end
end
