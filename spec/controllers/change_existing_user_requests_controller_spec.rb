require "rails_helper"

describe ChangeExistingUserRequestsController, type: :controller do
  def valid_requested_user_params
    {
      "name" => "subject",
      "email" => "subject@digital.cabinet-office.gov.uk",
    }
  end

  def valid_change_user_request_params
    {
      "support_requests_change_existing_user_request" => {
        "requester_attributes" => valid_requester_params,
        "requested_user_attributes" => {
          "name" => "subject",
          "email" => "subject@digital.cabinet-office.gov.uk",
        },
        "action" => "change_user",
        "additional_comments" => "",
      },
    }
  end

  before do
    login_as create(:user_manager)
    zendesk_has_no_user_with_email(@user.email)
  end

  context "submitted user creation request" do
    it "submits the request to Zendesk" do
      stub_ticket_creation = stub_zendesk_ticket_creation(
        hash_including("tags" => %w[govt_form change_user]),
      )

      post :create, params: valid_change_user_request_params

      expect(request).to redirect_to("/acknowledge")
      expect(stub_ticket_creation).to have_been_made
    end
  end
end
