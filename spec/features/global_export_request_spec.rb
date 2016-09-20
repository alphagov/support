require 'rails_helper'
require 'gds_api/test_helpers/support_api'

feature 'Exporting Global CSV of Feedback' do
  let(:user) { create :user_who_can_access_everything }

  background do
    stub_organisations_list

    login_as user
  end

  scenario 'spam is marked to be removed by default' do
    visit "/"

    click_link 'Feedback explorer'

    within('.global-export-request') do
      expect(page.find(:css, 'input[name="exclude_spam"]')).to be_checked
    end
  end
end
