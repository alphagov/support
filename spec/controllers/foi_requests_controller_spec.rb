require 'rails_helper'

describe FoiRequestsController, :type => :controller do
  before do
    login_as create(:api_user)
  end

  def valid_foi_request
    { "foi_request" =>
      {
        "requester" => { "name" => "A", "email" => "ab@c.com" },
        "details"   => "details"
      }
    }
  end

  context "new request" do
    it "acknowledges a valid request" do
      zendesk_has_no_user_with_email("ab@c.com")
      ticket_creation_request = stub_zendesk_ticket_creation
      post :create, params: valid_foi_request.merge(format: :json)

      expect(response).to have_http_status(201)
      expect(ticket_creation_request).to have_been_made
    end

    it "returns a JSON array of errors for invalid requests" do
      params = valid_foi_request.tap {|h| h["foi_request"]["requester"]["email"] = "a" }

      post :create, params: params.merge(format: :json)

      expect(response).to have_http_status(400)
      expect(json_response['errors']).to_not be_empty
    end
  end
end
