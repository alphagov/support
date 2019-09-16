require "rails_helper"

feature "Brexit checker request" do
  let(:user) do
    create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk")
  end

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "sucessful request for changing a result" do
    user_requests_change_to_result
  end

private

  def user_requests_change_to_result
    page_title = "Get ready for Brexit checker: change request"
    visit "/"
    click_on page_title
  end
end
