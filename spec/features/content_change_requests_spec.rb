require "rails_helper"

feature "Content change requests" do
  # In order to update or correct the information on GOV.UK
  # As a government employee
  # I want to inform GDS about what needs changing and why

  let(:user) { create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }
  let(:next_year) { Time.zone.now.year.succ }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful mainstream content change request " do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Update X",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form content_amend],
      "comment" => {
        "body" =>
"[Reason for request]
Factual inaccuracy

[Subject area]
Benefits

[Deadline date]
31-12-#{next_year}

[Deadline time]
13:00

[Do not publish before date]
01-12-#{next_year}

[Do not publish before time]
18:00

[URLs to be changed]
http://gov.uk/X

[Details of what should be added, amended or removed]
Out of date XX YY

[Reason for time constraint]
New law",
      },
      "custom_fields" =>
           [{ "id" => 7_948_652_819_356, "value" => "cr_inaccuracy" },
            { "id" => 7_949_106_580_380, "value" => "cr_benefits" },
            { "id" => 7_949_136_091_548, "value" => "2024-12-31" },
            { "id" => 7_949_152_975_772, "value" => "2024-12-01" },
            { "id" => 8_250_061_570_844, "value" => "13:00" },
            { "id" => 8_250_075_489_052, "value" => "18:00" }],
      "ticket_form_id" => 7_949_329_694_108,
    )

    user_makes_a_content_change_request(
      title: "Update X",
      reason_for_change: "Factual inaccuracy",
      subject_area: "Benefits",
      details_of_change: "Out of date XX YY",
      url: "http://gov.uk/X",
      related_urls: "http://gov.uk/welsh",
      needed_by_date: "31-12-#{next_year}",
      needed_by_time: "13:00",
      not_before_date: "01-12-#{next_year}",
      not_before_time: "18:00",
      reason: "New law",
    )

    expect(request).to have_been_made
  end

private

  def user_makes_a_content_change_request(details)
    visit "/"

    click_on "Request a content change or new content on GOV.UK"

    expect(page).to have_content("You'll get an automated response to confirm we've received your request. We'll then review your request within 2 working days.")

    fill_in "Title of request", with: details[:title] unless details[:title].nil?
    select details[:reason_for_change], from: "What’s the reason for the request?"
    select details[:subject_area], from: "What’s the subject area?"
    fill_in "Which URLs are affected?", with: details[:url]
    fill_in "Tell us about the content that needs to be created, updated or is causing a problem for users?", with: details[:details_of_change]

    user_fills_out_time_constraints(details)

    user_submits_the_request_successfully
  end
end
