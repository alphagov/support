require 'rails_helper'

feature "Emergency contact details" do
  # In order to recover from an emergency
  # As a departmental user
  # I want to phone somebody at GDS

  background do
    login_as create(:content_requester)
  end

  scenario "access the emergency contact details" do
    visit '/'

    click_on "Emergency contact details"

    expect(page).to have_content("05555 555 555") # Billy Director
    expect(page).to have_content("05555 555 556") # Bob Manager
  end
end
