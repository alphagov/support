require "rails_helper"

feature "New Content Data feedback" do
  let(:user) do
    create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk")
  end

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_support_api_to_receive_raise_ticket(
      "subject" => "Content Data feedback",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form content_data_feedback],
      "description" =>
"[Your feedback is about]
accessibility or usability

[Tell us a bit more]
I am having trouble reading the screen

[What's the impact on your work if we don't do anything about it?]
Cannot work",
    )

    user_provides_feedback(
      feedback_type: "accessibility or usability",
      description: "I am having trouble reading the screen",
      impact_on_work: "Cannot work",
    )

    expect(request).to have_been_made
  end

private

  def user_provides_feedback(details)
    visit "/"
    click_on "Give feedback on Content Data (Beta)"
    expect(page).to have_content("Give feedback on Content Data (Beta)")
    within "#feedback-type" do
      choose "accessibility or usability"
    end
    fill_in "Tell us a bit more", with: details[:description]
    fill_in "What's the impact on your work if we don't do anything about it?", with: details[:impact_on_work]
    user_submits_the_request_successfully
  end
end
