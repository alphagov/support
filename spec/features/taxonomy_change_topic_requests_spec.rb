require "rails_helper"

feature "Taxonomy topic change requests" do
  # In order to be able to tag my content to the most relevant part of the taxonomy on gov.uk
  # As a government employee
  # I want a means to ask GDS to change an existing topic in the taxonomy

  let(:user) { create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_support_api_to_receive_raise_ticket(
      "subject" => "Taxonomy change topic request - \"Abc\"",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form taxonomy_change_topic_request],
      "description" =>
"[Type of change]
Name of topic

[Requested topic]
Abc

[Details of changes]
Change the name to \"XYZ\".

[Reasons for changes]
People expect to find it here.",
    )

    user_makes_a_taxomomy_change_topic_request(
      title: "Abc",
      type_of_change: "Name of topic",
      details: "Change the name to \"XYZ\".",
      reasons: "People expect to find it here.",
    )

    expect(request).to have_been_made
  end

  scenario "retains entered values when validation fails" do
    visit "/"
    click_on "Suggest a change to a topic"

    title = "Early years curriculum"
    reasons = "People expect to find this topic here."

    fill_in "Name of topic you'd like changed", with: title
    choose "Name of topic"
    fill_in("Why do you think this change is needed? Please provide any evidence you have", with: reasons)

    click_on "Submit"

    expect(page).to have_field("Name of topic you'd like changed", with: title)
    expect(page).to have_checked_field("Name of topic")
    expect(page).to have_field("Why do you think this change is needed? Please provide any evidence you have", with: reasons)
  end

private

  def user_makes_a_taxomomy_change_topic_request(details)
    visit "/"

    click_on "Suggest a change to a topic"

    expect(page).to have_content("Suggest a change to a topic or the removal of a topic in the GOV.UK topic taxonomy.")

    fill_in "Name of topic you'd like changed", with: details[:title]

    choose details[:type_of_change]

    fill_in "Please give details of how you'd like the topic changed", with: details[:details]
    fill_in "Why do you think this change is needed? Please provide any evidence you have", with: details[:reasons]

    user_submits_the_request_successfully
  end
end
