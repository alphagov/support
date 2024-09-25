require "rails_helper"

describe CreateNewUserRequestsController, type: :controller do
  render_views

  def valid_requested_user_params
    {
      "name" => "subject",
      "email" => "subject@digital.cabinet-office.gov.uk",
      "organisation" => "Cabinet Office (CO)",
    }
  end

  def valid_create_user_request_params
    {
      "support_requests_create_new_user_request" => {
        "requester_attributes" => valid_requester_params,
        **valid_requested_user_params,
        "action" => "create_new_user",
        "whitehall_training" => "not_required",
        "access_to_other_publishing_apps" => "required",
        "additional_comments" => "not-blank",
      },
    }
  end

  before do
    login_as create(:user_manager)
    stub_support_api_organisations_list
  end

  it "submits the request to Zendesk" do
    stub_ticket_creation = stub_support_api_valid_raise_support_ticket(
      hash_including("tags" => %w[govt_form create_new_user]),
    )

    post :create, params: valid_create_user_request_params

    expect(request).to redirect_to("/acknowledge")
    expect(stub_ticket_creation).to have_been_made
  end

  it "re-displays the form with error messages if validation fails" do
    post :create, params: { "support_requests_create_new_user_request" => { "action" => "create_new_user" } }

    expect(controller).to have_rendered(:new)
    expect(response.body).to have_css(".alert", text: /Enter a name/)
    expect(response.body).to have_css(".alert", text: /Select if the user needs training or access to Whitehall Publisher/)
  end

  it "retains the previously selected organisation if validation fails" do
    post :create, params: { "support_requests_create_new_user_request" => { "organisation" => "Cabinet Office (CO)" } }

    expect(response.body).to have_css("select option[selected='selected'][value='Cabinet Office (CO)']")
  end
end
