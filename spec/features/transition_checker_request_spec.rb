require "rails_helper"

feature "Transition checker request" do
  let(:user) do
    create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk")
  end

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request for changing a result" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Get ready for new rules in 2021",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w(govt_form transition_checker),
      "comment" => {
        "body" =>
"[Action to change]
Action title

[Description of change]
Action description

[Change link to]
https://www.example.com",
      },
    )
    user_requests_change_to_result

    expect(request).to have_been_made
  end

  scenario "successful request for adding a result" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Get ready for new rules in 2021",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w(govt_form transition_checker),
      "comment" => {
        "body" =>
"[New action users]
Audience

[New action title]
Action

[New action consequence]
Consequence

[New action service link]
https://www.gov.uk/service-link

[New action guidance link]
https://www.gov.uk/guidance-link

[New action lead time]
Four weeks

[New action deadline]
End of October

[New action comments]
Comments

[New action priority]
High",
      },
    )
    user_requests_to_add_a_result

    expect(request).to have_been_made
  end

private

  def user_requests_change_to_result
    visit_transition_checker_request_page

    fill_in "support_requests_transition_checker_request_action_to_change", with: "Action title"
    fill_in "support_requests_transition_checker_request_description_of_change", with: "Action description"
    fill_in "support_requests_transition_checker_request_change_link_to", with: "https://www.example.com"

    user_submits_the_request_successfully
  end

  def user_requests_to_add_a_result
    visit_transition_checker_request_page

    fill_in "support_requests_transition_checker_request_new_action_users", with: "Audience"
    fill_in "support_requests_transition_checker_request_new_action_title", with: "Action"
    fill_in "support_requests_transition_checker_request_new_action_consequence", with: "Consequence"
    fill_in "support_requests_transition_checker_request_new_action_service_link", with: "https://www.gov.uk/service-link"
    fill_in "support_requests_transition_checker_request_new_action_guidance_link", with: "https://www.gov.uk/guidance-link"
    fill_in "support_requests_transition_checker_request_new_action_lead_time", with: "Four weeks"
    fill_in "support_requests_transition_checker_request_new_action_deadline", with: "End of October"
    fill_in "support_requests_transition_checker_request_new_action_comments", with: "Comments"
    select "High", from: "support_requests_transition_checker_request_new_action_priority"

    user_submits_the_request_successfully
  end

  def visit_transition_checker_request_page
    page_title = "Get ready for new rules in 2021 checker: change request"
    visit "/"
    click_on page_title
    expect(page).to have_content(page_title)
  end
end
