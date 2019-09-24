require "rails_helper"

feature "New taxonomy topic requests" do
  # In order to be able to tag my content to the most relevant part of the taxonomy on gov.uk
  # As a government employee
  # I want a means to ask GDS to add a new topic to the taxonomy

  let(:user) { create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Taxonomy new topic request - \"Abc\"",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form taxonomy_new_topic_request],
      "comment" => {
        "body" =>
"[Requested topic]
Abc

[URL of new topic]
https://www.gov.uk/government

[Evidence]
People expect to find it here.

[Parent topic]
Education, training and skills",
      },
    )

    user_makes_a_taxomomy_new_topic_request(
      title: "Abc",
      url: "https://www.gov.uk/government",
      details: "People expect to find it here.",
      parent: "Education, training and skills",
    )

    expect(request).to have_been_made
  end

private

  def user_makes_a_taxomomy_new_topic_request(details)
    visit "/"

    click_on "Suggest a new topic"

    expect(page).to have_content("Suggest a new topic for the GOV.UK taxonomy.")

    fill_in "Preferred name of new topic", with: details[:title]

    fill_in "URL(s) of page(s) you want to tag (provide as many as you can)", with: details[:url]
    fill_in "Why do you think this new topic is needed? Please provide any evidence you have", with: details[:details]
    fill_in "Where should this topic fit in the taxonomy? For example, a sub-topic of Early years curriculum", with: details[:parent]

    user_submits_the_request_successfully
  end
end
