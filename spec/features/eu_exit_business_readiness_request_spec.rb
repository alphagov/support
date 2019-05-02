require 'rails_helper'

feature 'New EU Exit Business Readiness Finder request' do
  let(:user) do
    create(:content_requester, name: 'John Smith', email: 'john.smith@agency.gov.uk')
  end

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario 'sucessful request for adding content' do
    request = expect_zendesk_to_receive_ticket(
      'subject' => 'EU Exit Business Readiness - /some/base/path',
      'priority' => 'normal',
      'requester' => hash_including('name' => 'John Smith', 'email' => 'john.smith@agency.gov.uk'),
      'tags' =>  %w[govt_form business_readiness dapper govt_form eu_exit],
      'comment' => {
        'body' =>
"[Type]
Adding content to the finder

[Url]
/some/base/path

[Pinned content]
Yes

[Sector]

Aerospace

[Organisation activity]

Buy products or goods from abroad
Sell products or goods abroad

[Employing eu citizens]
Yes

[Intellectual property]


[Funding schemes]


[Public sector procurement]

Civil government contracts"
      }
    )

    user_requests_update(
      request_type: 'Adding content to the finder'
    )

    expect(request).to have_been_made
  end

private

  def user_requests_update(details)
    page_title = 'Request updates to content in the EU Exit business readiness finder'
    visit '/'
    click_on page_title
    expect(page).to have_content(page_title)
    within '#support_requests_eu_exit_business_readiness_request_type_input' do
      choose details[:request_type]
    end
    within '#support_requests_eu_exit_business_readiness_request_pinned_content_input' do
      choose 'Yes'
    end
    within '#support_requests_eu_exit_business_readiness_request_sector_input' do
      check 'Aerospace'
    end
    within '#support_requests_eu_exit_business_readiness_request_organisation_activity_input' do
      check 'Buy products or goods from abroad'
      check 'Sell products or goods abroad'
    end
    within '#support_requests_eu_exit_business_readiness_request_employing_eu_citizens_input' do
      choose 'Yes'
    end
    within '#support_requests_eu_exit_business_readiness_request_public_sector_procurement_input' do
      check 'Civil government contracts'
    end
    fill_in 'URL of content', with: '/some/base/path'
    user_submits_the_request_successfully
  end
end
