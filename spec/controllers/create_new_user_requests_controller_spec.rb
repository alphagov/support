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
        "requires_additional_access" => "yes",
        "additional_comments" => "not-blank",
      },
    }
  end

  before do
    login_as create(:user_manager)
    zendesk_has_no_user_with_email(@user.email)
    stub_support_api_organisations_list
  end

  it "submits the request to Zendesk and creates a Zendesk user with the requested user details" do
    zendesk_has_no_user_with_email(valid_requested_user_params["email"])
    stub_ticket_creation = stub_zendesk_ticket_creation(
      hash_including("tags" => %w[govt_form create_new_user]),
    )
    stub_user_creation = stub_zendesk_user_creation(
      email: "subject@digital.cabinet-office.gov.uk",
      name: "subject",
      verified: true,
    )

    post :create, params: valid_create_user_request_params

    expect(request).to redirect_to("/acknowledge")
    expect(stub_ticket_creation).to have_been_made
    expect(stub_user_creation).to have_been_made
  end

  it "re-displays the form with error messages if validation fails" do
    post :create, params: { "support_requests_create_new_user_request" => { "action" => "create_new_user", "requires_additional_access" => "yes" } }

    expect(controller).to have_rendered(:new)

    expect(response.body).to have_css(".govuk-error-summary [role='alert']", text: error_message_for(:name, :blank))
    expect(response.body).to have_css(".govuk-error-summary [role='alert']", text: error_message_for(:additional_comments, :blank))

    expect(response.body).to have_css(".govuk-error-message", text: error_message_for(:name, :blank))
    expect(response.body).to have_css("input[name='support_requests_create_new_user_request[name]'].govuk-input--error")

    expect(response.body).to have_css(".govuk-error-message", text: error_message_for(:additional_comments, :blank))
    expect(response.body).to have_css("textarea[name='support_requests_create_new_user_request[additional_comments]'].govuk-textarea--error")
  end

  it "retains the previously selected organisation if validation fails" do
    post :create, params: { "support_requests_create_new_user_request" => { "organisation" => "Cabinet Office (CO)" } }

    expect(response.body).to have_css("select option[selected='selected'][value='Cabinet Office (CO)']")
  end

  it "doesn't expose an error to the user when automatic user creation goes wrong" do
    zendesk_is_unavailable

    allow_any_instance_of(Zendesk::ZendeskTickets).to receive(:raise_ticket)

    expect(GovukError).to receive(:notify)
      .with(kind_of(ZendeskAPI::Error::ClientError))

    post :create, params: valid_create_user_request_params

    expect(response).to redirect_to("/acknowledge")
  end

  it "provides an array of options for the organisation drop-down with a blank option and a 'None' option at the top" do
    expect(controller.send(:organisation_options).first).to eq("")
    expect(controller.send(:organisation_options).second).to eq("None")
  end

  it "returns no validation errors for alert, because this will be handled by #govuk_error_summary" do
    expect(controller.send(:validation_errors_for_alert)).to be_blank
  end

private

  def error_message_for(attribute_name, validation_type)
    I18n.t("activemodel.errors.models.support/requests/create_new_user_request.attributes.#{attribute_name}.#{validation_type}")
  end
end
