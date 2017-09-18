require 'rails_helper'

describe AccountsPermissionsAndTrainingRequestsController, type: :controller do
  def valid_requested_user_params
    {
      "name" => "subject",
      "email" => "subject@digital.cabinet-office.gov.uk",
      "job" => "editor",
      "phone" => "12345",
      "training" => %w(writing using_publisher),
      "other_training" => "Various other forms of training"
    }
  end

  def valid_create_user_request_params
    {
      "support_requests_accounts_permissions_and_training_request" => {
        "requester_attributes" => valid_requester_params,
        "requested_user_attributes" => valid_requested_user_params,
        "action" => "create_new_user",
        "user_needs" => "editor",
        "additional_comments" => ""
      }
    }
  end

  def valid_change_user_request_params
    {
      "support_requests_accounts_permissions_and_training_request" => {
        "requester_attributes" => valid_requester_params,
        "requested_user_attributes" => {
          "name" => "subject",
          "email" => "subject@digital.cabinet-office.gov.uk",
          "training" => %w(writing using_publisher),
          "other_training" => "Various other forms of training"
        },
        "action" => "change_user",
        "user_needs" => "writer",
        "additional_comments" => ""
      }
    }
  end

  before do
    login_as create(:user_manager)
    zendesk_has_no_user_with_email(@user.email)
  end

  context "submitted user creation request" do
    it "submits the request to Zendesk and creates a Zendesk user with the requested user details" do
      zendesk_has_no_user_with_email(valid_requested_user_params["email"])
      stub_ticket_creation = stub_zendesk_ticket_creation(
        hash_including("tags" => %w[govt_form create_new_user inside_government])
      )
      stub_user_creation = stub_zendesk_user_creation(
        email: "subject@digital.cabinet-office.gov.uk",
        name: "subject",
        details: "Job title: editor",
        phone: "12345",
        verified: true
      )

      post :create, params: valid_create_user_request_params

      expect(request).to redirect_to("/acknowledge")
      expect(stub_ticket_creation).to have_been_made
      expect(stub_user_creation).to have_been_made
    end

    it "doesn't make any changes to the Zendesk user for change user requests" do
      zendesk_ticket_request = stub_zendesk_ticket_creation

      post :create, params: valid_change_user_request_params

      expect(response).to redirect_to("/acknowledge")
      expect(zendesk_ticket_request).to have_been_made
    end

    it "doesn't expose an error to the user when automatic user creation goes wrong" do
      zendesk_is_unavailable

      allow_any_instance_of(Zendesk::ZendeskTickets).to receive(:raise_ticket)

      expect(GovukError).to receive(:notify)
        .with(kind_of(ZendeskAPI::Error::ClientError))

      post :create, params: valid_create_user_request_params

      expect(response).to redirect_to("/acknowledge")
    end

    context "concerning departments and policy" do
      it "tags the ticket with an inside_government tag" do
        stub_request = stub_zendesk_ticket_creation(
          hash_including("tags" => %w[govt_form change_user inside_government])
        )

        params = valid_change_user_request_params.tap { |p| p["support_requests_accounts_permissions_and_training_request"].merge!("user_needs" => "editor") }

        post :create, params: params

        expect(response).to redirect_to("/acknowledge")
        expect(stub_request).to have_been_made
      end
    end
  end
end
