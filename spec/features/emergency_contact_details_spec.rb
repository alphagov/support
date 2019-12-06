require "rails_helper"

feature "Emergency contact details" do
  # In order to recover from an emergency
  # As a departmental user
  # I want to phone somebody at GDS

  background do
    login_as create(:user)
  end

  before do
    allow(ENV).to receive(:[]).with(anything)
    allow(ENV).to receive(:[])
      .with("EMERGENCY_CONTACT_DETAILS")
      .and_return(contacts_json)
  end

  context "with all contacts supplied" do
    let(:contacts_json) do
      File.read(Rails.root.join("config/emergency_contact_details.json"))
    end

    scenario "access the emergency contact details" do
      visit "/"

      click_on "Emergency contact details"

      expect(page).to have_content("05555 555 555") # Billy Director
      expect(page).to have_content("05555 555 556") # Bob Manager
    end
  end

  context "when secondary contacts are missing" do
    let(:contacts_json) do
      contacts = JSON.parse File.read(Rails.root.join("config/emergency_contact_details.json"))
      contacts.reject { |k, _| k == "secondary_contacts" }.to_json
    end

    scenario "access the emergency contact details" do
      visit "/"

      click_on "Emergency contact details"

      expect(page).to have_content("National emergency publishing")
      expect(page).not_to have_content("05555 555 556") # Bob Manager
    end
  end
end
