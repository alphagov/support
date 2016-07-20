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
      "comment" => { "body" =>
"[Needed by date]
31-12-2020

[Not before date]
01-12-2020

[Reason for time constraint]
Legal requirement

[Which part of GOV.UK is this about?]
Departments and policy

[User need]
Information on XYZ

[Url of example]
http://www.example.com"})

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

    click_on "Changes to publishing applications or technical advice"

    expect(page).to have_content("Request for changes or new features for any publishing applications or ask for technical advice. Also used for transitioning new sites to GOV.UK")

    fill_in "Title of request", with: details[:title]

    within "#request-context" do
      choose details[:context]
    end

    fill_in "What is the user need/feature request?", with: details[:user_need]
    fill_in "Can you provide a link to an example of this feature?", with: details[:url_of_example]

    user_fills_out_time_constraints(details)

    user_submits_the_request_successfully
  end
end
