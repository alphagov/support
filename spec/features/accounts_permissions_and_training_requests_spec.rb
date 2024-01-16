require "rails_helper"

feature "Accounts, permissions and training requests" do
  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
  end

  scenario "redirect legacy path to home page" do
    visit "/accounts_permissions_and_training_request/new"
    expect(page).to have_current_path(root_path)
  end
end
