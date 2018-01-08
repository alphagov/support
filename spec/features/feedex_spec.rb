require 'rails_helper'
require 'gds_api/test_helpers/support_api'

feature 'Exploring anonymous feedback' do
  include GdsApi::TestHelpers::SupportApi
  include ActionDispatch::TestProcess

  background do
    login_as create(:user)
  end

  scenario 'exploring feedback by list of urls' do
    stub_support_api_anonymous_feedback(
      { path_prefixes: ['/vat-rates', '/done', '/vehicle-tax'] },
      list_of_urls_path_results
    )

    feedback_reports = [
      {
        'Date' => '1 Mar 2013',
        'Feedback' => 'Action: Looking at 3rd paragraph Problem: Typo in 2rd word',
        'URL' => '/vat-rates',
        'Referrer' => '/'
      }, {
        'Date' => '1 Feb 2013',
        'Feedback' => 'Action: Looking at done page Problem: A paragraph is misaligned',
        'URL' => '/done',
        'Referrer' => '/pay-vat'
      },
      {
        'Date' => '1 Feb 2013',
        'Feedback' => 'Action: Looking at vehicle tax page Problem: Not enough detail about how to get in contact',
        'URL' => '/vehicle-tax',
        'Referrer' => '/pay-vehicle-tax'
      }
    ]

    explore_anonymous_feedback_by_urls(list_of_urls: 'www.gov.uk/vat-rates, www.gov.uk/done, /vehicle-tax')
    expect(feedex_results).to eq(feedback_reports)
  end

  scenario 'exploring feedback by uploaded list of urls' do
    stub_support_api_anonymous_feedback(
      { path_prefixes: ['/vat-rates', '/done', '/vehicle-tax'] },
      list_of_urls_path_results
    )

    feedback_reports = [
      {
        'Date' => '1 Mar 2013',
        'Feedback' => 'Action: Looking at 3rd paragraph Problem: Typo in 2rd word',
        'URL' => '/vat-rates',
        'Referrer' => '/'
      }, {
        'Date' => '1 Feb 2013',
        'Feedback' => 'Action: Looking at done page Problem: A paragraph is misaligned',
        'URL' => '/done',
        'Referrer' => '/pay-vat'
      },
      {
        'Date' => '1 Feb 2013',
        'Feedback' => 'Action: Looking at vehicle tax page Problem: Not enough detail about how to get in contact',
        'URL' => '/vehicle-tax',
        'Referrer' => '/pay-vehicle-tax'
      }
    ]

    explore_anonymous_feedback_by_urls(uploaded_list: "#{Rails.root}/spec/fixtures/list_of_urls.csv")
    expect(feedex_results).to eq(feedback_reports)
  end

  scenario 'no feedback found for list of urls' do
    stub_support_api_anonymous_feedback(
      { path_prefixes: ['/non-existent-path'] },
      no_results
    )

    explore_anonymous_feedback_by_urls(list_of_urls: 'https://www.gov.uk/non-existent-path')

    expect(page).to have_content('There’s no feedback for the URL(s) requested.')
  end

  scenario 'no feedback found for uploaded list of urls' do
    stub_support_api_anonymous_feedback(
      { path_prefixes: ['/non-existent-path', '/second-non-existent-path', '/third-non-existent-path'] },
      no_results
    )

    explore_anonymous_feedback_by_urls(uploaded_list: "#{Rails.root}/spec/fixtures/list_of_nonexistent_urls.csv")

    expect(page).to have_content('There’s no feedback for the URL(s) requested.')
  end

  scenario 'exploring feedback by organisation' do
    stub_support_api_anonymous_feedback_organisation_summary(
      'cabinet-office',
      'last_7_days',
      cabinet_office_last_7_days_summary_results
    )
    stub_support_api_document_type_list

    organisation_summary = [
      {
        'Page' => '/vat-rates',
        '7 days' => '5 items',
        '30 days' => '10 items',
        '90 days' => '20 items',
      }, {
        'Page' => '/done',
        '7 days' => '0 items',
        '30 days' => '0 items',
        '90 days' => '0 items',
      }, {
        'Page' => '/vehicle-tax',
        '7 days' => '0 items',
        '30 days' => '0 items',
        '90 days' => '0 items',
      }
    ]

    explore_anonymous_feedback_by_organisation('Cabinet Office')
    expect(page).to have_content('Feedback for Cabinet Office')
    expect(organisation_summary_results).to eq(organisation_summary)
  end

  scenario 'exploring feedback by document type' do
    stub_support_api_anonymous_feedback_doc_type_summary(
      'smart_answer',
      'last_7_days',
      smart_answer_last_7_days_summary_results
    )
    stub_support_api_organisations_list

    doctype_summary = [
      {
        'Page' => '/vat-rates',
        '7 days' => '5 items',
        '30 days' => '10 items',
        '90 days' => '20 items',
      }, {
        'Page' => '/done',
        '7 days' => '0 items',
        '30 days' => '0 items',
        '90 days' => '0 items',
      }, {
        'Page' => '/vehicle-tax',
        '7 days' => '0 items',
        '30 days' => '0 items',
        '90 days' => '0 items',
      }
    ]

    explore_anonymous_feedback_by_document_type('Smart Answer')
    expect(page).to have_content('Feedback for documents of type smart_answer')
    expect(doctype_summary_results).to eq(doctype_summary)
  end

  scenario 'exploring feedback by organisation, list of urls and document_type' do
    stub_support_api_document_type_list
    stub_support_api_organisation('cabinet-office')
    org_summary_request = stub_support_api_anonymous_feedback_organisation_summary(
      'cabinet-office',
      'last_7_days',
      cabinet_office_last_7_days_summary_results
    )

    org_feedback_request = stub_support_api_anonymous_feedback(
      { organisation_slug: 'cabinet-office' },
      list_of_urls_path_results
    )

    org_and_path_feedback_request = stub_support_api_anonymous_feedback(
      { organisation_slug: 'cabinet-office', path_prefixes: ['/vat-rates', '/done', '/vehicle-tax'] },
      list_of_urls_path_results
    )

    path_feedback_request = stub_support_api_anonymous_feedback(
      { path_prefixes: ['/vat-rates', '/done', '/vehicle-tax'] },
      list_of_urls_path_results
    )

    doctype_org_and_path_request = stub_support_api_anonymous_feedback(
      { path_prefixes: ['/vat-rates', '/done', '/vehicle-tax'],
        organisation_slug: 'cabinet-office',
        document_type: 'smart_answer' },
      list_of_urls_path_results
    )

    doctype_and_path_request = stub_support_api_anonymous_feedback(
      { path_prefixes: ['/vat-rates', '/done', '/vehicle-tax'],
        document_type: 'smart_answer' },
      list_of_urls_path_results
    )

    explore_anonymous_feedback_by_organisation('Cabinet Office')

    expect(org_summary_request).to have_been_requested
    expect(org_feedback_request).not_to have_been_requested
    expect(org_and_path_feedback_request).not_to have_been_requested
    expect(path_feedback_request).not_to have_been_requested

    click_on 'All feedback for Cabinet Office'

    expect(org_feedback_request).to have_been_requested
    expect(org_and_path_feedback_request).not_to have_been_requested
    expect(path_feedback_request).not_to have_been_requested

    expect(page).to have_title('Feedback for “Cabinet Office”')
    expect(page).to have_select('Organisation', selected: 'Cabinet Office (CO)')

    # NOTE: this doesn't work as the value of the input is nil and that doesn't
    # match '' (capybara to_s's the with so we can't pass in nil either
    # expect(page).to have_field('URL', with: '')

    empty_url_field = page.find_field('paths')
    expect(empty_url_field).not_to be_nil
    expect(empty_url_field.value).to be_blank

    fill_in 'paths', with: '/vat-rates, /done, /vehicle-tax'
    click_on 'Filter'

    expect(org_and_path_feedback_request).to have_been_requested
    expect(path_feedback_request).not_to have_been_requested

    expect(page).to have_title('Feedback for “Cabinet Office on /vat-rates and 2 other paths”')
    expect(page).to have_select('Organisation', selected: 'Cabinet Office (CO)')
    expect(page).to have_field('paths', with: '/vat-rates, /done, /vehicle-tax')

    select 'Smart Answer', from: 'Document Type'
    click_on 'Filter'

    expect(doctype_org_and_path_request).to have_been_requested
    expect(page).to have_title('“Cabinet Office on /vat-rates and 2 other paths - Document type: smart answer”')
    expect(page).to have_select('Organisation', selected: 'Cabinet Office (CO)')
    expect(page).to have_select('Document Type', selected: 'Smart Answer')
    expect(page).to have_field('paths', with: '/vat-rates, /done, /vehicle-tax')

    click_on 'Remove organisation filter'

    expect(doctype_and_path_request).to have_been_requested
    expect(page).to have_title('Feedback for “/vat-rates and 2 other paths - Document type: smart answer”')
    expect(page).to have_select('Organisation', selected: [])
    expect(page).to have_select('Document Type', selected: ['Smart Answer'])
    expect(page).to have_field('paths', with: '/vat-rates, /done, /vehicle-tax')

    click_on 'Remove document type filter'

    expect(page).to have_title('Feedback for “/vat-rates and 2 other paths”')
    expect(page).to have_select('Organisation', selected: [])
    expect(page).to have_select('Document Type', selected: [])
    expect(page).to have_field('paths', with: '/vat-rates, /done, /vehicle-tax')

    expect(path_feedback_request).to have_been_requested
  end

  let(:list_of_urls_path_results) do
    {
      'current_page' => 1,
      'pages' => 1,
      'page_size' => 3,
      'results' => [
        {
          type: 'problem-report',
          path: '/vat-rates',
          url: 'http://www.dev.gov.uk/vat-rates',
          created_at: Time.parse('2013-03-01'),
          what_doing: 'looking at 3rd paragraph',
          what_wrong: 'typo in 2rd word',
          referrer: 'https://www.gov.uk/',
        },
        {
          type: 'problem-report',
          path: '/done',
          url: 'http://www.dev.gov.uk/done',
          created_at: Time.parse('2013-02-01'),
          what_doing: 'looking at done page',
          what_wrong: 'a paragraph is misaligned',
          referrer: 'https://www.gov.uk/pay-vat',
        },
        {
          type: 'problem-report',
          path: '/vehicle-tax',
          url: 'http://www.dev.gov.uk/vehicle-tax',
          created_at: Time.parse('2013-02-01'),
          what_doing: 'looking at vehicle tax page',
          what_wrong: 'not enough detail about how to get in contact',
          referrer: 'https://www.gov.uk/pay-vehicle-tax',
        }
      ]
    }
  end

  let(:no_results) do
    { 'results' => [], 'pages' => 0, 'current_page' => 1 }
  end

  let(:cabinet_office_last_7_days_summary_results) do
    {
      'title' => 'Cabinet Office',
      'slug' => 'cabinet-office',
      'anonymous_feedback_counts' => [
        { path: '/vat-rates', last_7_days: 5, last_30_days: 10, last_90_days: 20 },
        { path: '/done' },
        { path: '/vehicle-tax' },
      ],
    }
  end

  let(:smart_answer_last_7_days_summary_results) do
    {
      'title' => 'Smart Survey',
      'document_type' => 'smart_answer',
      'anonymous_feedback_counts' => [
        { path: '/vat-rates', last_7_days: 5, last_30_days: 10, last_90_days: 20 },
        { path: '/done' },
        { path: '/vehicle-tax' },
      ],
    }
  end
end
