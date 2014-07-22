require 'rails_helper'

feature "New feature requests" do
  # In order to fulfill user needs not currently met by gov.uk
  # As a government employee
  # I want a means to contact GDS and request new features

  let(:user) { create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Abc - New Feature Request",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => [ "govt_form", "new_feature_request", "inside_government" ],
      "fields" => [
        { "id" => GDSZendesk::FIELD_MAPPINGS[:needed_by_date], "value" => "31-12-2020" },
        { "id" => GDSZendesk::FIELD_MAPPINGS[:not_before_date], "value" => "01-12-2020" }
      ],
      "comment" => { "body" =>
"[Which part of GOV.UK is this about?]
Departments and policy

[User need]
Information on XYZ

[Url of example]
http://www.example.com

[Time constraint reason]
Legal requirement"})

    user_makes_a_new_feature_request(
      title: "Abc",
      context: "Departments and policy",
      user_need: "Information on XYZ",
      url_of_example: "http://www.example.com",
      needed_by_date: "31-12-2020",
      not_before_date: "01-12-2020",
      reason: "Legal requirement",
    )

    expect(request).to have_been_made
  end

  private
  def user_makes_a_new_feature_request(details)
    visit '/'

    click_on "New feature/need"

    expect(page).to have_content("Request a new feature/need")

    fill_in "Title of request", with: details[:title]

    within "#request-context" do
      choose details[:context]
    end

    fill_in "What is the user need/feature request?", with: details[:user_need]
    fill_in "Can you provide a link to an example of this feature?", with: details[:url_of_example]

    user_fills_out_time_constraints(details)

    user_submits_the_request_successfully
  end

  def user_fills_out_time_constraints(details)
    fill_in "MUST be published by", with: details[:needed_by_date]
    fill_in "MUST NOT be published BEFORE", with: details[:not_before_date]
    fill_in "Reason for the above dates", with: details[:reason]
  end
end
