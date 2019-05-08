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
    stub_facet_group_lookup(Support::Requests::EuExitBusinessReadinessRequest::EU_EXIT_BUSINESS_FINDER_CONTENT_ID)
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

  def stub_facet_group_lookup(content_id = "FACET-GROUP-UUID")
    uri_regex = Regexp.new("publishing-api.*?\/v2\/expanded-links\/#{content_id}")
    stub_request(:get, uri_regex)
    .to_return(body: {
      content_id: content_id,
      expanded_links: facet_group,
      version: 54_321,
    }.to_json)
  end

  def facet_group
    {
      "content_id" => "FACET-GROUP-UUID",
      "title" => "Find EU Exit guidance business",
      "facets" => [
        {
          "content_id" => "FACET-UUID",
          "title" => "Sector / Business area",
          "details" => { "key" => "sector_business_area" },
          "links" => {
            "facet_values" => [
              {
                "content_id" => "ANOTHER-FACET-VALUE-UUID",
                "title" => "Aerospace",
                "details" => {
                  "label" => "Aerospace",
                  "value" => "aerospace",
                }
              }
            ]
          }
        },
        {
          "content_id" => "FACET-UUID1",
          "title" => "Organisation activity",
          "details" => { "key" => "business_activity" },
          "links" => {
            "facet_values" => [
              {
                "content_id" => "ANOTHER-FACET-VALUE-UUID1",
                "title" => "Buy products or goods from abroad",
                "details" => {
                  "label" => "Buy products or goods from abroad",
                  "value" => "buying",
                  }
              },
              {
                "content_id" => "ANOTHER-FACET-VALUE-UUID2",
                "title" => "Sell products or goods from abroad",
                "details" => {
                  "label" => "Sell products or goods abroad",
                  "value" => "selling",
                  }
              }
            ]
          }
        },
        {
          "content_id" => "FACET-UUID1",
          "title" => "Who you employ",
          "details" => { "key" => "employ_eu_citizens" },
          "links" => {
            "facet_values" => [
              {
                "content_id" => "ANOTHER-FACET-VALUE-UUID1",
                "title" => "EU citizens",
                "details" => {
                  "label" => "EU citizens",
                  "value" => "yes",
                  }
              },
            ]
          }
        },
        {
          "content_id" => "FACET-UUID",
          "title" => "Personal data",
          "details" => { "key" => "personal_data" },
          "links" => {
            "facet_values" => [
              {
                "content_id" => "ANOTHER-FACET-VALUE-UUID",
                "title" => "Processing personal data from Europe",
                "details" => {
                  "label" => "Processing personal data from Europe",
                  "value" => "processing-personal-data",
                }
              }
            ]
          }
        },
        {
          "content_id" => "FACET-UUID",
          "title" => "Intellectual property",
          "details" => { "key" => "intellectual_property" },
          "links" => {
            "facet_values" => [
              {
                "content_id" => "ANOTHER-FACET-VALUE-UUID",
                "title" => "Copyright",
                "details" => {
                  "label" => "Copyright",
                  "value" => "copyright",
                }
              }
            ]
          }
        },
        {
          "content_id" => "FACET-UUID",
          "title" => "EU or UK government funding",
          "details" => { "key" => "eu_uk_government_funding" },
          "links" => {
            "facet_values" => [
              {
                "content_id" => "ANOTHER-FACET-VALUE-UUID",
                "title" => "EU funding",
                "details" => {
                  "label" => "EU funding",
                  "value" => "eu-funding",
                }
              }
            ]
          }
        },
        {
          "content_id" => "FACET-UUID",
          "title" => "Public sector procurement",
          "details" => { "key" => "public_sector_procurement" },
          "links" => {
            "facet_values" => [
              {
                "content_id" => "ANOTHER-FACET-VALUE-UUID",
                "title" => "Civil government contracts",
                "details" => {
                  "label" => "Civil government contracts",
                  "value" => "civil-government-contracts",
                }
              }
            ]
          }
        }
      ]
    }
  end
end
